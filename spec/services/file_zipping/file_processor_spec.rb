require "rails_helper"

RSpec.describe FileZipping::FileProcessor do
  describe "#call" do
    let(:user) { User.create(email_address: "jan@example.com", password: "abc") }
    let(:file_content) { "File content" }
    let(:uploaded_file) do
      tempfile = Tempfile.new(%w[test_file .txt], encoding: "UTF-8")
      tempfile.write(file_content)
      tempfile.rewind
      Rack::Test::UploadedFile.new(tempfile.path, 'text/plain')
    end
    subject { FileZipping::FileProcessor.new(params).call }

    after do
      uploaded_file.close
      uploaded_file.unlink
    end

    context "when an unzipped file exists" do
      let(:params) { { unzipped_file: uploaded_file, user_id: user.id } }

      it "attaches a file to the archive property" do
        expect(subject.archive_file).to be_attached
      end

      it "saves the attached file with .zip extension" do
        expect(subject.archive_file.filename.to_s).to include ".zip"
      end

      it "creates a valid zip archive containing the original file" do
        decode_password = Zip::TraditionalDecrypter.new(subject.archive_password)
        archive_file_path = ActiveStorage::Blob.service.send(:path_for, subject.archive_file.key)

        Zip::InputStream.open(File.open(archive_file_path, "r"), decrypter: decode_password) do |input|
          entry = input.get_next_entry
          expect(entry.name).to eq "#{uploaded_file.original_filename}"
          expect(input.read).to eq(file_content)
        end
      end
    end

    context "when an unzipped file doesn't exist" do
      let(:params) { { user_id: user.id } }

      it "it returns nil" do
        expect(subject).to be_nil
      end
    end
  end
end
