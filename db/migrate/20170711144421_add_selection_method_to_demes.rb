class AddSelectionMethodToDemes < ActiveRecord::Migration[5.1]
  def change
    change_table :demes do |t|
      t.string :selection_method
    end
  end
end
