class CgpProgram < ApplicationRecord
  has_one :program, as: :programmable

  def evaluate(inputs)
    cgp = CGP.new(self.gene, TrainingDatum::NUM_FEATURES, 1)
    return cgp.evaluate(inputs)[0]
  rescue => ex
    return nil
  end

  def randomize
    self.gene = CGP.random_program(TrainingDatum::NUM_FEATURES,1,50)
  end

  def mutate
    self.gene = CGP.mutate(self.gene, TrainingDatum::NUM_FEATURES, 1)
  end

end
