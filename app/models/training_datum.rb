class TrainingDatum < ApplicationRecord
  NUM_FEATURES=21
  def inputs
    self.attributes.select{|k,v|k.include?"feature"}.values
  end
  def expected_output
    return self.target
  end
end
