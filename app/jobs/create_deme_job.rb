class CreateDemeJob < ApplicationJob
  queue_as :default

  def perform(population_size = 10)
    Rails.logger.warn("CreateDemeJob")
    # Do something later
    d = Deme.new
    # Set our max size.
    # Eventually, may want this to fluctuate...
    d.max_size = population_size
    # This should help constrain size...
    d.max_program_size = 50
    d.save!
    population_size.times do 
      p = d.programs.build
      p.randomize
      p.generation = d.generation
      p.save
    end
    # Should be good, run generation:
    RunGenerationJob.perform_later(d.id)
  end
end
