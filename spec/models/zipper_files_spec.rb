require "rails_helper"

RSpec.describe ZipperFile, type: :model do
  describe "callbacks" do
    describe "zip_uploaded_file" do
      let(:file_content) { "File content" }
      let(:uploaded_file) do
        tempfile = Tempfile.new(%w[test_file .txt])
        tempfile.write(file_content)
        tempfile.rewind
        Rack::Test::UploadedFile.new(tempfile.path, 'text/plain')
      end
      let(:zipped_file) { ZipperFile.new(unzipped_file: uploaded_file) }

      after do
        uploaded_file.close
        uploaded_file.unlink
      end

      context "when an unzipped file exists" do
        it "attaches a file to the archive property" do
          zipped_file.save!
          expect(zipped_file.archive_file).to be_attached
        end

        it "saves the attached file with .zip extension" do
          zipped_file.save!
          expect(zipped_file.archive_file.filename.to_s).to include ".zip"
        end

        it "creates a valid zip archive containing the original file" do
          zipped_file.save!

          temp_zip_path = Tempfile.new(["downloaded_archive", ".zip"]).path
          File.open(temp_zip_path, "wb") do |file|
            file.write(zipped_file.archive_file.download)
          end

          Zip::File.open(temp_zip_path) do |zip_file|
            entry = zip_file.entries.first

            expect(entry.name).to include "test_file"
            expect(entry.get_input_stream.read).to eq(file_content)
          end
        end
      end

      context "when an unzipped file doesn't exist" do
        it "does not attach any file" do
          zip = ZipperFile.new
          zip.save!
          expect(zip.archive_file).not_to be_attached
        end
      end
    end
  end
end
