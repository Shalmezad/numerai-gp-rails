class AddGenerationToPrograms < ActiveRecord::Migration[5.1]
  def change
    change_table :programs do |t|
      t.integer :generation
    end
  end
end
