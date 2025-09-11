require "zip"

class ZipperFile < ApplicationRecord
  has_one_attached :archive_file
  attr_accessor :unzipped_file

  before_save :zip_uploaded_file, if: :unzipped_file

  private

  def zip_uploaded_file
    return unless unzipped_file.present?

    temp_zip = Tempfile.new(%w[archive_file .zip])
    temp_path = temp_zip.path
    original_filename = unzipped_file.original_filename

    Zip::File.open(temp_path, create: true) do |zip_file|
      zip_file.add(original_filename, unzipped_file.path)
    end

    self.archive_file.attach(
      io: File.open(temp_path),
      filename: "#{original_filename}.zip",
      content_type: "application/zip"
    )

    temp_zip.close
    temp_zip.unlink
  end
end
