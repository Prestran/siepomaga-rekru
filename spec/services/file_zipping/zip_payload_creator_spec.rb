require "rails_helper"

RSpec.describe FileZipping::ZipPayloadCreator do
  describe "#call" do
    let(:user) { User.create(email_address: "jan@example.com", password: "abc") }
    let(:file_content) { "File content" }
    let(:uploaded_file) do
      tempfile = Tempfile.new(%w[test_file .txt], encoding: "UTF-8")
      tempfile.write(file_content)
      tempfile.rewind
      Rack::Test::UploadedFile.new(tempfile.path, 'text/plain')
    end
    let(:base_url) { "http://test.com" }
    let(:zipper_file) { ZipperFile.create(name: "Test", archive_password: "TestPassword", user_id: user.id) }

    subject { FileZipping::ZipPayloadCreator.new(zipper_file, base_url).call }

    after do
      uploaded_file.close
      uploaded_file.unlink
    end

    context "zipper_file doesn't have an archive_file attached" do
      it "returns nil" do
        expect(subject).to be_nil
      end
    end

    context "zipper_file has an archive_file attached" do
      before do
        zipper_file.archive_file.attach(
          io: File.open(uploaded_file.path),
          filename: "#{uploaded_file.original_filename}.zip",
          content_type: "application/zip"
        )
      end

      it "returns a Hash" do
        expect(subject).to be_a Hash
      end

      it "returns zipper_files's archive_file and password" do
        expect(subject[:file_url]).to eq base_url + Rails.application.routes.url_helpers.rails_blob_path(zipper_file.archive_file, only_path: true)
        expect(subject[:file_password]).to eq zipper_file.archive_password
      end
    end
  end
end
