class BuildNextGenerationJob < ApplicationJob
  queue_as :default

  def perform(deme_id)
    # Do something later
    Rails.logger.warn "BuildNextGenerationJob"
    deme = Deme.find(deme_id)
    # Save the stats for later:
    deme.create_generation_stats
    # Nice part is, the puts nil at the end, so "dead" programs are still in the running... ish
    ids = deme.programs.where(:generation => deme.generation).order("log_loss asc").pluck(:id)

  end
end
