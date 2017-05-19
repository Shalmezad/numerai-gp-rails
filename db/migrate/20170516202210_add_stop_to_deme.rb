class AddStopToDeme < ActiveRecord::Migration[5.1]
  def change
    change_table :demes do |t|
      t.boolean :stop, :default => false
    end
  end
end
