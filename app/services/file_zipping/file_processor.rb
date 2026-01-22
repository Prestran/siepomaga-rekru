require "zip"
require "securerandom"

module FileZipping
  class FileProcessor
    attr_reader :unzipped_file
    def initialize(params)
      @zipper_file = ZipperFile.new(params)
      @unzipped_file = params[:unzipped_file]
    end

    def call
      zip_and_save_uploaded_file
    end

    private

    def zip_and_save_uploaded_file
      return unless unzipped_file.present?

      @temp_zip = Tempfile.new(%w[archive_file .zip])
      @original_filename = unzipped_file.original_filename
      @random_password = SecureRandom.hex

      encrypt_and_save_zip
      save_archive_attachment_properties
      temp_file_cleanup

      @zipper_file
    end

    def encrypt_and_save_zip
      encrypter = Zip::TraditionalEncrypter.new(@random_password)

      Zip::OutputStream.open(@temp_zip.path, encrypter: encrypter) do |output|
        output.put_next_entry(@original_filename)
        output.write File.read(unzipped_file)
      end
    end

    def save_archive_attachment_properties
      @zipper_file.archive_file.attach(
        io: File.open(@temp_zip.path),
        filename: "#{@original_filename}.zip",
        content_type: "application/zip"
      )
      @zipper_file.archive_password = @random_password

      @zipper_file.save
    end

    def temp_file_cleanup
      TempFileCleanerJob.perform_later(path: @temp_zip.path)
    end
  end
end
