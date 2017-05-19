class RunGenerationJob < ApplicationJob
  queue_as :default

  def perform(deme_id)
    # Do something later
    Rails.logger.warn("RunGenerationJob: #{deme_id}")
    #
  end
end
