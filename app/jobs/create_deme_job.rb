class CreateDemeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.warn("CreateDemeJob")
    # Do something later
    d = Deme.new
    d.save!
    5.times do 
      p = d.programs.build
      p.randomize
      p.save
    end
    # Should be good, run generation:
    RunGenerationJob.perform_later(d.id)
  end
end
