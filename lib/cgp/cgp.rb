class CGP
  OPERATIONS = [
    # Just left
    lambda{|x,y| x},
    # Just right
    lambda{|x,y| y},
    # sqrt x + y:
    lambda{|x,y| Math.sqrt(((x + y)/2).abs)},
    # sqrt x - y:
    lambda{|x,y| Math.sqrt((x-y).abs)},
    # l + r:
    lambda{|x,y| x + y},
    # l - r:
    lambda{|x,y| (x - y).abs},
    # 1 - l
    lambda{|x,y| (1-x).abs},
    # 1 - r
    lambda{|x,y| (1-y).abs},
    # 1
    lambda{|x,y| 1},
    # 0
    lambda{|x,y| 0},
    # 0.5
    lambda{|x,y| 0.5},
    # x > y
    lambda{|x,y| x > y ? 1 : 0},
    # x < y
    lambda{|x,y| x < y ? 1 : 0}

  ]

  NUM_OPERATORS = OPERATIONS.size

  attr_accessor :middle_tokens
  attr_accessor :output_sources

  def self.random_program(num_in, num_out, num_mid)
    # Alright, we need to build a random program:
    # So, let's build each of the middle ones:
    prog = []
    num_mid.times do |i|
      # Our index is actual num_in + i
      index = num_in + i
      # We can use any nodes before our index
      lhs = (rand() * index).to_i
      rhs = (rand() * index).to_i
      # And choose an operator:
      op = (rand() * NUM_OPERATORS).to_i
      # And add it to our program:
      prog << [lhs, rhs, op]
    end
    # Now, we need our outputs:
    num_out.times do |i|
      # Can be anything before the outputs:
      source = (rand() * (num_in + num_mid)).to_i
      prog << source
    end
    return prog.flatten.join(" ")
  end

  def self.mutate(prog_str, num_in, num_out, mutate_chance = 0.05)
    # Make a temporary program:
    prog = CGP.new(prog_str, num_in, num_out)
    middle = prog.middle_tokens
    outs = prog.output_sources
    # Go through each middle node:
    middle.each_with_index do |node, i|
      index = num_in + i
      # Should we mutate lhs?
      if rand() < mutate_chance
        middle[i][0] = (rand() * index).to_i
      end
      # rhs?
      if rand() < mutate_chance
        middle[i][1] = (rand() * index).to_i
      end
      # op
      if rand() < mutate_chance
        middle[i][2] = (rand() * NUM_OPERATORS).to_i
      end
    end
    # Go through each output:
    outs.each_with_index do |out, i|
      if rand() < mutate_chance
        outs[i] = (rand() * (num_in + middle.size)).to_i
      end
    end

    return (middle + outs).flatten.join(" ")

  end

  def initialize(str, num_inputs, num_outputs, debug=false)
    @num_inputs = num_inputs
    @num_outputs = num_outputs
    # So, the string.
    # Based on Miller's paper, it's a series of numbers
    # So, let's split the string up first:
    tokens = str.split.map{|x|x.to_i}
    # Alright, now let's break it up into 2 pieces:
    # The last num_outputs tokens are for the output
    @output_sources = tokens.pop(num_outputs)
    # And the rest are grouped by 3:
    @middle_tokens = tokens.each_slice(3).to_a
    # Now, ahead of time, we're going to also allocate memory
    # We need a spot for each of our inputs, and middle tokens:
    @memory = {}
    if debug
      puts "Loaded program:"
      puts "  Middle Tokens: "
      @middle_tokens.each do |mt|
        puts "    #{mt.join(" ")}"
      end
      puts "  Output sources: #{@output_sources.join(" ")}"
    end
  end

  def evaluate(inputs, debug=false)
    @inputs = inputs
    outputs = @output_sources.map{|x|evaluate_node(x)}
    return outputs
  end

  def evaluate_node(node_index, debug=false)
    # Are we an input node?
    if node_index < @num_inputs
      return @inputs[node_index]
    end
    # Do we have a cache?
    if !@memory[node_index]
      # Figure out which memory node we need:
      node = @middle_tokens[node_index - @num_inputs]
      # Get our left:
      lhs = evaluate_node(node[0])
      rhs = evaluate_node(node[1])
      op = node[2]
      result = OPERATIONS[op].call(lhs, rhs)
      @memory[node_index] = [0,result,1].sort[1]
    end
    return @memory[node_index]
  rescue => ex
    puts "Error:"
    puts "LHS: #{lhs}"
    puts "RHS: #{rhs}"
    puts "OP: #{op}"
    raise
  end
end
