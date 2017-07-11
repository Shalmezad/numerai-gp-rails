class BuildNextGenerationJob < ApplicationJob
  queue_as :bottleneck
  MUTATION_CHANCE = 0.8

  WEIGHTED_SELECTION = 1
  TOURNAMENT_SELECTION = 2
  ONE_PLUS_N_SELECTION = 3
  SELECTION_METHOD = ONE_PLUS_N_SELECTION

  def perform(deme_id)
    # Do something later
    Rails.logger.warn "BuildNextGenerationJob"
    deme = Deme.find(deme_id)
    # Save the stats for later:
    deme.create_generation_stats
    # Nice part is, the puts nil at the end, so "dead" programs are still in the running... ish
    ids = deme.programs.where(:generation => deme.generation).order("log_loss asc").pluck(:id)
    # Clone the best one we have, and run validation job:
    best_id = ids.first
    best_program = Program.find(best_id).dup
    best_program.save
    RunValidationJob.perform_later(best_program.id)

    # Do our selection
    if deme.selection_method == Deme.SELECTION_METHODS[:weighted]
      perform_weighted_selection(deme, ids)
    elsif deme.selection_method == Deme.SELECTION_METHODS[:tournament]
      perform_tournament_selection(deme, ids)
    elsif deme.selection_method == Deme.SELECTION_METHODS[:one_plus_n]
      perform_one_plus_n_selection(deme, ids)
    end
    # Destroy the old programs:
    Program.where(:id => ids).destroy_all
    # Bump up our generation:
    deme.generation += 1
    deme.save
    # And run (if we haven't been told to stop)
    if !deme.stop
      RunGenerationJob.perform_later(deme.id)
    end
  end

  def perform_tournament_selection(deme, ids)
    ids.shuffle.each_slice(4).to_a.each do |tourny|
      programs = Program.find(tourny)
      if tourny.size == 4
        # Have the tournament
        # Pick the 2 highest ones
        programs = programs.sort_by{|p|p.log_loss || 100000000}
        # Grab #1:
        a = programs[0]
        # Grab #2:
        b = programs[1]
        # Put them in the next generation:
        add_gene_to_next_generation(deme, a.gene)
        add_gene_to_next_generation(deme, b.gene)
        # Put their children in the next generation:
        new_genes = cross(a.gene, b.gene)
        add_gene_to_next_generation(deme, new_genes[0])
        add_gene_to_next_generation(deme, new_genes[1])
      else
        # Just put them in the next generation
        programs.each do |p2|
          add_gene_to_next_generation(deme, p2.gene)
        end
      end
    end
  end

  def perform_weighted_selection(deme, ids)
    deme.max_size.times do
      # Create a new program. We'll select 2 ids:
      a_id = pick_id(ids)
      b_id = pick_id(ids)
      # Grab their genes:
      #gene_a = Program.where(:id => a_id).pluck(:gene)[0].split
      #gene_b = Program.where(:id => b_id).pluck(:gene)[0].split
      gene_a = Program.find(a_id).gene
      gene_b = Program.find(b_id).gene

      # Cross them:
      # BUT, we're only after one gene, so only take one of them:
      new_gene = cross(gene_a, gene_b).sample
      # And add it to our next generation:
      add_gene_to_next_generation(deme, new_gene)
    end
  end

  def perform_one_plus_n_selection(deme, ids)
    # ids are already sorted. 
    # Our first one is the best:
    best_gene = Program.find(ids.first).gene
    ids.each_with_index do |i, index|
      add_gene_to_next_generation(deme, best_gene, index!=0)
    end
  end

  def cross(gene_a, gene_b)
    # Get the tokens:
    ta = gene_a.split
    tb = gene_b.split
    # Pick a spot to split
    index_a = (ta.size * rand()).to_i
    index_b = (tb.size * rand()).to_i
    # And build 2 new genes via cross
    # So:
    # AAAAAA BBBBBB
    # Could become:
    # AAAABB BBBBAA
    new_expr_a = ta[0...index_a] + tb[index_b..-1]
    new_expr_b = tb[0...index_b] + ta[index_a..-1]
    return [new_expr_a.join(" "), new_expr_b.join(" ")]
  end

  def add_gene_to_next_generation(deme, gene, allow_mutate=true)
    p = deme.programs.build
    p.gene = gene
    p.generation = deme.generation + 1
    p.save
    # See if we should mutate
    if allow_mutate && rand() < MUTATION_CHANCE
      p.mutate
      p.save
    end
    # See if we need to crop:
    #if !deme.max_program_size.nil?
    #  p.reload
    #  tokens = p.gene.split
    #  if tokens.size > deme.max_program_size
    #    while tokens.size > deme.max_program_size
    #      tokens.delete_at(rand(tokens.length))
    #    end
    #    p.gene = tokens.join(" ")
    #    p.save
    #  end
    #end
  end

  def pick_id(ids)
    # We'll go with the approach I used in the last one:
    # X chance of picking the first one. If not, go to the second
    # X chance of picking that one. If not, go to the next
    # So on down the list
    ids.each do |id|
      if rand < 0.5
        return id
      end
    end
    return ids.last
  end
end
