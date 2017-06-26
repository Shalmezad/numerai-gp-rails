class CreatePostfixPrograms < ActiveRecord::Migration[5.1]
  def change
    create_table :postfix_programs do |t|
      t.string :gene

      t.timestamps
    end
  end
end
