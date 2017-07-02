class AddProgramTypeToDemes < ActiveRecord::Migration[5.1]
  def change
    change_table :demes do |t|
      t.string :program_type
    end
  end
end
