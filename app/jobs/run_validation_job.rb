require "#{Rails.root}/lib/math/math"
class RunValidationJob < ApplicationJob
  queue_as :validation

  #ValidatedProgram
  def perform(validated_program_id)
    # We have a program id, and an array of training data ids
    # Find the program, measure it's fitness (log-loss across set)
    Rails.logger.warn "Measuring fitness for #{validated_program_id}"
    p = Program.find validated_program_id
    #actual_outputs = []
    #expected_outputs = []
    logLosses = []
    dead = false
    # We have a bunch of ids, group them into batches of N:
    training_datum_ids = TrainingDatum.where(:data_type => "validation").pluck(:id)
    n = 500
    training_datum_ids.each_slice(n).each do |id_subset|
      TrainingDatum.find(id_subset).each do |td|
        #Rails.logger.warn "  #{program_id} < #{training_datum_id}"
        #td = TrainingDatum.find(training_datum_id)
        expected_output = td.expected_output
        actual_output = p.output(td.inputs)
        if actual_output.nil?
          # Program crashed, therefor is dead:
          dead = true
          break
        end
        # Going to normalize the actual output for easy of use:
        actual_output = (Math.tanh(actual_output)+1)/2
        loss = Math.logLoss(actual_output, expected_output)
        logLosses << loss
      end
      break if dead
    end #training_datum_ids.each_slice(n).each

    if !dead
      # Average the log losses
      avg = logLosses.inject(:+)/logLosses.size
      p.log_loss = avg
    else
      p.log_loss = nil
    end
    p.save
    
    # Is it better than what's on the deme:
    if p.deme.best_log_loss.nil? || p.log_loss < p.deme.best_log_loss
      # Save it:
      Deme.transaction do
        deme = p.deme
        deme.best_gene = p.gene
        deme.best_log_loss = p.log_loss
        deme.save
      end
    end
  end



end
