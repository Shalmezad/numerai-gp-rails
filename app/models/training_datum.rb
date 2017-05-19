class TrainingDatum < ApplicationRecord
  def inputs
  end
  def expected_output
    return self.target
  end
end
