class CreateFixedNumPrograms < ActiveRecord::Migration[5.1]
  def change
    create_table :fixed_num_programs do |t|

      t.timestamps
    end
  end
end
