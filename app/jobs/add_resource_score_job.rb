class AddResourceScoreJob < ApplicationJob
  queue_as :bottleneck

  def perform(deme_id)
    # We're going to give a total 10% error subtraction for using resources:
    # So, each one get's a % reduction
    reduction_per_feature = 0.10 / TrainingDatum::NUM_FEATURES
    feature_use_counts = Array.new(TrainingDatum::NUM_FEATURES){|x|0}
    # Now, we go through each of our programs, and count which features are used:
    Program.where(:deme_id => deme_id).each do |p|
      TrainingDatum::NUM_FEATURES.times do |i|
        s = "i" + i.to_s
        if p.gene.include? s
          feature_use_counts[i] += 1
        end
      end
    end
    # Figure out how much each use gets rewarded:
    rewards = feature_use_counts.map{|x|reduction_per_feature/x}
    # And add the rewards:
    Program.where(:deme_id => deme_id).each do |p|
      next if p.log_loss.nil?
      p.resource_bonus = 0 
      TrainingDatum::NUM_FEATURES.times do |i|
        s = "i" + i.to_s
        if p.gene.include? s
          p.resource_bonus += rewards[i]
        end
      end
      # Apply resource bonus to logloss:
      p.log_loss *= (1 - p.resource_bonus)
      p.save
    end
    
    BuildNextGenerationJob.perform_later(deme_id)
  end
end
