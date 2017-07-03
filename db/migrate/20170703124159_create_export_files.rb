class CreateExportFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :export_files do |t|
      t.string :path
      t.string :status

      t.timestamps
    end
  end
end
