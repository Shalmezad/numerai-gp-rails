class CreateDemes < ActiveRecord::Migration[5.1]
  def change
    create_table :demes do |t|

      t.timestamps
    end
  end
end
