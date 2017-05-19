class AddMaxSizeToDemes < ActiveRecord::Migration[5.1]
  def change
    change_table :demes do |t|
      t.integer :max_size, :default => 20
    end
  end
end
