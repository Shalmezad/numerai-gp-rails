require "#{Rails.root}/lib/math/math"
class MeasureFitnessJob < ApplicationJob
  queue_as :fitness
  batchable

  def perform(program_id, training_datum_ids)
    # We have a program id, and an array of training data ids
    # Find the program, measure it's fitness (log-loss across set)
    Rails.logger.warn "Measuring fitness for #{program_id}"
    p = Program.find program_id
    #actual_outputs = []
    #expected_outputs = []
    logLosses = []
    dead = false
    # We have a bunch of ids, group them into batches of N:
    n = 100
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
    Rails.logger.warn "  #{program_id} loss: #{avg.nil? ? "DEAD" : avg}"
  end

end
