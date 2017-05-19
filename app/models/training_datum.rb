class TrainingDatum < ApplicationRecord
  def inputs
    self.attributes.select{|k,v|k.include?"feature"}.values
  end
  def expected_output
    return self.target
  end
end
