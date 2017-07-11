class CreateDemeJob < ApplicationJob
  queue_as :default

  #def perform(population_size = 10, program_type="PostfixProgram")
  def perform(opts={})
    d = Deme.new(opts)
    # This should help constrain size...
    #d.max_program_size = 500
    # Save
    d.save!
    # Build our population
    d.max_size.times do 
      p = d.programs.build
      p.randomize(d.max_program_size)
      p.generation = d.generation
      p.save
    end
    # Should be good, run generation:
    RunGenerationJob.perform_later(d.id)
  end
end
