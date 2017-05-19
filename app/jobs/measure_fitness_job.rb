class MeasureFitnessJob < ApplicationJob
  queue_as :default
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
    training_datum_ids.each do |training_datum_id|
      Rails.logger.warn "  #{program_id} < #{training_datum_id}"
      td = TrainingDatum.find(training_datum_id)
      expected_output = td.expected_output
      actual_output = p.output(td.inputs)
      if actual_output.nil?
        # Program crashed, therefor is dead:
        dead = true
        break
      end
      loss = logLoss(expected_output, actual_output)
      logLosses << loss
    end

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

  def logLoss(act, pred, eps=1e-15)
    pred = [eps, pred].max
    pred = [1-eps, pred].min
    ll = act * Math.log(pred) + (1-act) * Math.log(1-pred)
    ll = ll * -1
    return ll
  end


end
