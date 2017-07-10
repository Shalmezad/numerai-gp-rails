class FixedNumProgram < ApplicationRecord
  has_one :program, as: :programmable
  FIXED_NUM = 0.5
  def evaluate(input)
    return FIXED_NUM
  end

  def gene
    return FIXED_NUM.to_s
  end

  def gene=(gene)
    # Don't do anything
  end

  def randomize
    # poof
  end

  def mutate
    # Wow. Such code. Much magic.
  end
end
