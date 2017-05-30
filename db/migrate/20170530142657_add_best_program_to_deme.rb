class AddBestProgramToDeme < ActiveRecord::Migration[5.1]
  def change
    change_table :demes do |t|
      t.text :best_gene, :limit => nil
      t.decimal :best_log_loss
    end
  end
end
