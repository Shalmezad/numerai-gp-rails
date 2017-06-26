class PostfixProgram < ApplicationRecord
  has_one :program, as: :programmable

  # Given set of inputs, give output
  def evaluate(inputs)
    pf = Postfix.new(self.gene)
    return pf.evaluate(inputs)
  rescue => ex
    return nil
  end

  # Replaces gene with a completely random generated gene
  def randomize
    tokens = []
    num_tokens = (rand() * 20).to_i
    num_tokens.times do
      token = random_token
      tokens << token
    end
    self.gene = tokens.join(" ")
  end

  # Returns a [weighted] random token
  def random_token
    chance_symbol = 80 # +, -, *, /, etc
    chance_input = 40 # i40, i21, etc
    chance_number = 20

    total = chance_symbol + chance_input + chance_number
    stick = rand() * total

    token = nil
    if stick < chance_symbol
      token = ["+", "-", "*", "/", "log", "log10", "tanh"].sample
    elsif stick < chance_symbol + chance_input
      token = "i" + (rand() * TrainingDatum::NUM_FEATURES).to_i.to_s
    else
      token = (rand() * 2 - 1).to_s
    end

    return token
  end

  # Mutates my gene
  def mutate
    return if self.gene.nil?
    chance_mutate = 20
    chance_add = 50
    chance_delete = 25
    chance_swap = 25
    total = chance_mutate + chance_add + chance_delete + chance_swap
    stick = rand() * total

    tokens = self.gene.split
    i = (rand() * tokens.size).to_i
    if stick < chance_mutate
      # Mutate a token:
      tokens[i] = random_token
    elsif stick < chance_mutate + chance_delete
      # Delete:
      num_deletions = (rand() * [5,tokens.size].min).to_i
      num_deletions.times do
        i = (rand() * tokens.size).to_i
        tokens.delete_at(i)
      end
    elsif stick < chance_mutate + chance_delete + chance_add
      # Add:
      num_additions = (rand() * 5).to_i
      num_additions.times do
        tokens.insert(i, random_token)
      end
    else
      # Swap:
      i2 = (rand() * tokens.size).to_i
      a = tokens[i]
      tokens[i] = tokens[i2]
      tokens[i2] = a
    end

    self.gene = tokens.join(" ")
  end




end
