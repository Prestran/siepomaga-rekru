class CreateZipperFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :zipper_files do |t|
      t.text :name

      t.timestamps
    end
  end
end
