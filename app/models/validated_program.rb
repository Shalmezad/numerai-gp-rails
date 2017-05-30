require "#{Rails.root}/lib/postfix/postfix"

class ValidatedProgram < ApplicationRecord
  def output(inputs)
    pf = Postfix.new(self.gene)
    return pf.evaluate(inputs)
  rescue => ex
    return nil
  end
end
