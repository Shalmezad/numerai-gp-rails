class Deme < ApplicationRecord
  has_many :programs

  def stop_run
    self.update_attributes :stop => true
  end

  def start_run
    self.update_attributes :stop => false
    RunGenerationJob.perform_later(self.id)
  end

  def create_generation_stats
    # Builds the stats for the current generation
    # Also sends them off to any interested parties.
    log_losses = self.programs.where(:generation => self.generation).order("log_loss asc").pluck(:log_loss)
    total = log_losses.size
    # Remove dead genes:
    log_losses = log_losses.select{|x|!x.nil?}
    # TODO: Add dead_count to generation stat
    dead_count = total - log_losses.size
    best_gene = self.programs.where(:generation => self.generation).order("log_loss asc").limit(1).pluck(:gene)
    min = log_losses.min
    max = log_losses.max
    avg = log_losses.inject(:+)/log_losses.size rescue 0
    gs = GenerationStat.create({
      :deme_id => self.id,
      :generation => self.generation,
      :best_gene => best_gene,
      :min => min,
      :max => max,
      :avg => avg
    })
  end

end
