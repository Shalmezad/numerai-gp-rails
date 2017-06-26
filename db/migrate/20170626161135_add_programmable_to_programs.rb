class AddProgrammableToPrograms < ActiveRecord::Migration[5.1]
  def change
    change_table :programs do |t|
      t.integer :programmable_id
      t.string :programmable_type
    end
    remove_column :programs, :gene, :text
  end
end
