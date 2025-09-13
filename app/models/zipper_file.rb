require "zip"
require "securerandom"

class ZipperFile < ApplicationRecord
  Zip.force_entry_names_encoding = "UTF-8"

  has_one_attached :archive_file

  attr_accessor :unzipped_file

  before_save :zip_and_save_uploaded_file, if: :unzipped_file

  private

  def zip_and_save_uploaded_file
    return unless unzipped_file.present?

    @temp_zip = Tempfile.new(%w[archive_file .zip])
    @original_filename = unzipped_file.original_filename
    @random_password = SecureRandom.hex

    encrypt_and_save_zip
    save_archive_attachment_properties
    temp_file_cleanup
  end

  def encrypt_and_save_zip
    encrypter = Zip::TraditionalEncrypter.new(@random_password)

    Zip::OutputStream.open(@temp_zip.path, encrypter: encrypter) do |output|
      output.put_next_entry(@original_filename)
      output.write File.read(unzipped_file)
    end
  end

  def save_archive_attachment_properties
    self.archive_file.attach(
      io: File.open(@temp_zip.path),
      filename: "#{@original_filename}.zip",
      content_type: "application/zip"
    )
    self.archive_password = @random_password
  end

  def temp_file_cleanup
    @temp_zip.close
    @temp_zip.unlink
  end
end
