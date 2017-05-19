class RunGenerationJob < ApplicationJob
  queue_as :default

  def perform(deme_id)
    Rails.logger.warn("RunGenerationJob: #{deme_id}")
    # So the plan is:
    # a) split into a bunch of measure fitness jobs
    # b) regroup into a build next generation job

    deme = Deme.find(deme_id)

    # So ideally I want something like
    batch = BatChi.batch
    # Build the next generation after we're done measuring:
    # batch.callback(BuildNextGenerationJob, deme_id)
    batch.callback(AddResourceScoreJob, deme_id)
    # Select the training data to use:
    num_inputs = 5
    training_ids = TrainingDatum.order("RANDOM()").limit(num_inputs).pluck(:id)
    # Create a job for each of the programs
    program_ids = deme.programs.where(:generation => deme.generation).pluck(:id)
    program_ids.each do |program_id|
      batch.add(MeasureFitnessJob, program_id, training_ids)
    end
    batch.start
  end
end
