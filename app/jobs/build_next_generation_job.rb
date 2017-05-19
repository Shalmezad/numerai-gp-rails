class BuildNextGenerationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    Rails.logger.warn "BuildNextGenerationJob"
  end
end
