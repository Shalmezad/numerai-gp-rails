require_relative "stack"

class Postfix
  # Takes in a string
  def initialize(expr)
    @expr = expr
  end

  def evaluate(inputs=[])
    stack = Stack.new
    tokens.each do |token|
      if numeric?(token)
        stack.push(token.to_f)
      elsif token.start_with? "i"
        if inputs.size == 0
          raise "Trying to use 'i' token with 0 inputs"
        end
        # input:
        index = token[1..-1].to_i % inputs.size
        stack.push(inputs[index])
      elsif token == "+"
        rhs = stack.pop
        lhs = stack.pop
        stack.push(lhs + rhs)
      elsif token == "*"
        rhs = stack.pop
        lhs = stack.pop
        stack.push(lhs * rhs)
      elsif token == "-"
        rhs = stack.pop
        lhs = stack.pop
        stack.push(lhs - rhs)
      else
        raise "Unknown token: #{token}"
      end
    end
    stack.pop
  end

  def tokens
    to_a
  end

  def to_s
    @expr
  end

  def to_a
    @expr.split(" ")
  end

  def numeric?(string)
    no_commas =  string.gsub(',', '')
    matches = no_commas.match(/-?\d+(?:\.\d+)?/)
    if !matches.nil? && matches.size == 1 && matches[0] == no_commas
      true
    else
      false
    end
  end

end

