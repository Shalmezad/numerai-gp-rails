class CreateBasicRulePrograms < ActiveRecord::Migration[5.1]
  def change
    create_table :basic_rule_programs do |t|
      t.string :gene

      t.timestamps
    end
  end
end
