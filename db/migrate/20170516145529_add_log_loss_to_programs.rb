class AddLogLossToPrograms < ActiveRecord::Migration[5.1]
  def change
    change_table :programs do |t|
      t.decimal :log_loss
    end
  end
end
