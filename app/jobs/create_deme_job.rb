class CreateDemeJob < ApplicationJob
  queue_as :default

  def perform(population_size = 10)
    Rails.logger.warn("CreateDemeJob")
    # Do something later
    d = Deme.new
    d.save!
    population_size.times do 
      p = d.programs.build
      p.randomize
      p.save
    end
    # Should be good, run generation:
    RunGenerationJob.perform_later(d.id)
  end
end
