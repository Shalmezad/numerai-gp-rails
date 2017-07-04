class AddProgramToExportFiles < ActiveRecord::Migration[5.1]
  def change
    change_table :export_files do |t|
      t.string :program
      t.string :program_type
    end
  end
end
