class MeasureFitnessJob < ApplicationJob
  queue_as :default
  batchable

  def perform(*args)
    # Do something later
  end
end
