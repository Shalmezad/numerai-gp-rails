class BuildNextGenerationJob < ApplicationJob
  queue_as :default

  def perform(deme_id)
    # Do something later
    Rails.logger.warn "BuildNextGenerationJob"
    deme = Deme.find(deme_id)
    # Nice part is, the puts nil at the end, so "dead" programs are still in the running... ish
    ids = deme.programs.order("log_loss asc").pluck(:id)

  end
end
