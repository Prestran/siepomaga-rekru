require "zip"
require 'securerandom'

class ZipperFile < ApplicationRecord
  has_one_attached :archive_file

  attr_accessor :unzipped_file

  before_save :zip_uploaded_file, if: :unzipped_file

  private

  def zip_uploaded_file
    return unless unzipped_file.present?

    temp_zip = Tempfile.new(%w[archive_file .zip], encoding: "utf-8")
    temp_zip_path = temp_zip.path
    original_filename = unzipped_file.original_filename

    random_password = SecureRandom.hex
    encrypter = Zip::TraditionalEncrypter.new(random_password)

    writing_buffer = Zip::OutputStream.write_buffer(encrypter: encrypter) do |output|
      output.put_next_entry(original_filename)
      output.write File.read(unzipped_file)
    end

    File.open(temp_zip_path, "wb") do |file|
      file.write(writing_buffer.string)
    end

    self.archive_file.attach(
      io: File.open(temp_zip_path),
      filename: "#{original_filename}.zip",
      content_type: "application/zip"
    )
    self.archive_password = random_password

    temp_zip.close
    temp_zip.unlink
  end
end
