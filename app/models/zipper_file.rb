require "zip"

class ZipperFile < ApplicationRecord
  Zip.force_entry_names_encoding = "UTF-8"

  has_one_attached :archive_file

  attr_accessor :unzipped_file
end
