class AddArchivePasswordToZipperFile < ActiveRecord::Migration[8.0]
  def change
    add_column :zipper_files, :archive_password, :text
  end
end
