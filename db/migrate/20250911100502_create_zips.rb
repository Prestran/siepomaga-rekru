class CreateZips < ActiveRecord::Migration[8.0]
  def change
    create_table :zips do |t|
      t.text :name

      t.timestamps
    end
  end
end
