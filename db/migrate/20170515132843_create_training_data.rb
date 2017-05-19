class CreateTrainingData < ActiveRecord::Migration[5.1]
  def change
    create_table :training_data do |t|
      #id,era,data_type,feature1,feature2,[...],feature21,target
      #140721,era1,train,0.26647,0.42487,[...],0.53739,1
      t.integer :n_id
      t.string :era
      t.string :data_type
      21.times do |i|
        field_name = "feature#{i+1}"
        t.decimal field_name.to_sym
      end
      t.integer :target
    end
  end
end
