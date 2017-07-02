class CreateDemeJob < ApplicationJob
  queue_as :default

  def perform(population_size = 10, program_type="PostfixProgram")
    d = Deme.new
    # Set our max size.
    # Eventually, may want this to fluctuate...
    d.max_size = population_size
    # This should help constrain size...
    d.max_program_size = 500
    # Set the type:
    d.program_type = program_type
    # Save
    d.save!
    # Build our population
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
