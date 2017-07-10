# BasicRuleProgram consists of 4 member tuples like so:
# [I3 > I7 -0.01]
# which evaluates to:
# "If Input#3 is greater than Input#7, 
#   subtract 0.01 from our base 0.5 prediction"
# And to put it generically:
# [ LHS OP RHS MOD ]
# LHS/RHS variable/constants to check
# OP comparison operator to apply
# MOD modification to the base prediction if the statement is true
class BasicRuleProgram < ApplicationRecord
  has_one :program, as: :programmable

  def evaluate(inputs)
    tups = self.gene.split.each_slice(4).to_a
    result = 0.5
    tups.each do |tup|
      lhs = evaluate_token(tup[0],inputs)
      op = tup[1]
      rhs = evaluate_token(tup[2],inputs)
      mod = tup[3].to_f
      if op == ">" && lhs > rhs
        result += mod 
      elsif op == "<" && lhs < rhs
        result += mod
      end
    end
    return result
  #rescue => ex
  #  return nil
  end

  def evaluate_token(token, inputs)
    if token.start_with? "i"
      index = token[1..-1].to_i % inputs.size
      return inputs[index]
    else
      return token.to_f
    end
  end

  def randomize(max_tups = 5)
    # How many tuples to generate?
    num_tups = (rand() * max_tups).to_i
    tups = []
    num_tups.times do 
      # Need a random token or 2:
      lhs = random_token
      rhs = random_token
      op = (rand() < 0.5 ? "<" : ">")
      mod = random_mod
      tups << [lhs, op, rhs, mod]
    end
    self.gene = tups.flatten.join(" ")
  end

  def random_token
    if rand() < 0.7
      return "i" + (rand() * TrainingDatum::NUM_FEATURES).to_i.to_s
    else
      return rand().to_s
    end
  end

  def random_mod
    mod_shift = 0.001
    return (rand() * mod_shift) - (mod_shift/2)
  end

  def mutate(mutate_chance = 0.2)
    tups = self.gene.split.each_slice(4).to_a
    tups.each_with_index do |tup, i|
      # Change lhs?
      if rand() < mutate_chance
        tups[i][0] = random_token
      end
      # Change op?
      if rand() < mutate_chance
        tups[i][1] = (rand() < 0.5 ? "<" : ">")
      end
      # Change rhs?
      if rand() < mutate_chance
        tups[i][2] = random_token
      end
      # Change mod?
      if rand() < mutate_chance
        tups[i][3] = random_mod
      end
    end
    self.gene = tups.flatten.join(" ")
  end

end
