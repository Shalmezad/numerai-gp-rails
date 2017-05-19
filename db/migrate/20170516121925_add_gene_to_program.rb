class AddGeneToProgram < ActiveRecord::Migration[5.1]
  def change
    change_table :programs do |t|
      t.text :gene, :limit => nil
    end
  end
end
