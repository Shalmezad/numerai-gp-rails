class MeasureFitnessJob < ApplicationJob
  queue_as :default
  batchable

  def perform(program_id, training_datum_ids)
    # We have a program id, and an array of training data ids
    # Find the program, measure it's fitness (log-loss across set)
  end
end
