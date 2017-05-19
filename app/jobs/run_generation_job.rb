class RunGenerationJob < ApplicationJob
  queue_as :default

  def perform(deme_id)
    Rails.logger.warn("RunGenerationJob: #{deme_id}")
    # So the plan is:
    # a) split into a bunch of measure fitness jobs
    # b) regroup into a build next generation job

    # So ideally I want something like
    batch = BatChi.batch
    batch.callback(BuildNextGenerationJob, deme_id)
    5.times do |i|
      batch.add(MeasureFitnessJob, i)
    end
    batch.start
  end
end
