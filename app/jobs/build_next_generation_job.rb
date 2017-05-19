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
    deme.max_size.times do
      # Create a new program. We'll select 2 ids:
      a_id = pick_id(ids)
      b_id = pick_id(ids)
      # Grab their genes:
      gene_a = Program.where(:id => a_id).pluck(:gene)[0].split
      gene_b = Program.where(:id => b_id).pluck(:gene)[0].split
      # Pick a spot to split
      index_a = (gene_a.size * rand()).to_i
      index_b = (gene_b.size * rand()).to_i
      # And build 2 new genes via cross
      # So:
      # AAAAAA BBBBBB
      # Could become:
      # AAAABB BBBBAA
      new_expr_a = gene_a[0...index_a] + gene_b[index_b..-1]
      new_expr_b = gene_b[0...index_b] + gene_a[index_a..-1]
      # BUT, we're only after one gene
      # So need to pick one...
      new_gene = [new_expr_a, new_expr_b].sample
      # And build a new program:
      p = deme.programs.build
      p.gene = new_gene
      p.generation = deme.generation + 1
      p.save
    end
    # Destroy the old programs:
    Program.where(:id => ids).destroy_all
    # Bump up our generation:
    deme.generation += 1
    deme.save
    # And run!
    RunGenerationJob.perform_later(deme.id)
  end

  def pick_id(ids)
    # We'll go with the approach I used in the last one:
    # X chance of picking the first one. If not, go to the second
    # X chance of picking that one. If not, go to the next
    # So on down the list
    ids.each do |id|
      if rand < 0.7
        return id
      end
    end
    return ids.last
  end
end
