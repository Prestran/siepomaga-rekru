require "rails_helper"

RSpec.describe "ZipperFiles", type: :request do
  let(:uploaded_file) do
    tempfile = Tempfile.new(%w[test_file .txt], encoding: "UTF-8")
    tempfile.write("File Content")
    tempfile.rewind
    Rack::Test::UploadedFile.new(tempfile.path, 'text/plain')
  end

  describe "POST /zipper_files" do
    it "returns successful response and path for newly zipped file and its password" do
      post "/zipper_files", params: { name: "Name", unzipped_file: uploaded_file }
      json_body = JSON.parse(response.body)

      expect(response).to be_successful

      expect(json_body["file_url"]).to include uploaded_file.original_filename
      expect(json_body["file_password"]["password"]).to include ZipperFile.last.archive_password
    end

    it "returns unsuccessful response when ZipperFile cannot be saved" do
      post "/zipper_files"
      expect(response).not_to be_successful
    end
  end

  describe "GET /zipper_files" do
    it "returns http success" do
      get "/zipper_files"
      expect(response).to have_http_status(:success)
    end
  end
end
