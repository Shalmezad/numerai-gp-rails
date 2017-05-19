class AddGenerationToDeme < ActiveRecord::Migration[5.1]
  def change
    change_table :demes do |t|
      t.integer :generation, :default => 1
    end
  end
end
