class CreateDemeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.warn("CreateDemeJob")
    # Do something later
    d = Deme.new
    d.save!
    # TODO: populate
    # Should be good, run generation:
    RunGenerationJob.perform_later(d.id)
  end
end
