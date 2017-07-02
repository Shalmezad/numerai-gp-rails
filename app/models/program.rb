require "#{Rails.root}/lib/postfix/postfix"

class Program < ApplicationRecord
  belongs_to :deme
  belongs_to :programmable, :polymorphic => true, :inverse_of => :program, autosave: true

  #after_initialize :set_programmable
  after_save :save_programmable

  def initialize(params)
    super(params)
    set_programmable
  end

  def set_programmable
    if self.deme && self.deme.program_type
      clazz = self.deme.program_type.constantize
      self.programmable = clazz.new
    end
  end

  def save_programmable
    self.programmable.save
  end

  def randomize
    self.programmable.randomize
  end

  def output(inputs)
    evaluate(inputs)
  end

  def evaluate(inputs)
    self.programmable.evaluate(inputs)
  end

  def gene=(g)
    self.programmable.gene = g
  end

  def gene
    self.programmable.gene
  end

  def mutate
    self.programmable.mutate
    self.programmable.save
  end

end
