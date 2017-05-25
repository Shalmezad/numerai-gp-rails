class AddResourceBonusToPrograms < ActiveRecord::Migration[5.1]
  def change
    change_table :programs do |t|
      t.decimal :resource_bonus
    end
  end
end
