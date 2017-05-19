class CreateGenerationStats < ActiveRecord::Migration[5.1]
  def change
    create_table :generation_stats do |t|
      t.references :deme
      t.integer :generation
      t.string :best_gene
      t.decimal :min
      t.decimal :max
      t.decimal :avg

      t.timestamps
    end
  end
end
