class AddMaxProgramSizeToDeme < ActiveRecord::Migration[5.1]
  def change
    change_table :demes do |t|
      t.integer :max_program_size
    end
  end
end
