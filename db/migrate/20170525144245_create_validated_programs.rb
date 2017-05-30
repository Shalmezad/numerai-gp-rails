class CreateValidatedPrograms < ActiveRecord::Migration[5.1]
  def change
    create_table :validated_programs do |t|
      t.text :gene
      t.decimal :total_log_loss
      t.integer :total_tested
      t.decimal :avg_log_loss

      t.timestamps
    end
  end
end
