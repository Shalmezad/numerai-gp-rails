require File.dirname(__FILE__) + "/batchi"
require File.dirname(__FILE__) + "/batchable"

module BatChi

  IS_A_BATCHED_JOB_KEY="IamAbatchiBatchjob"

  class Engine < ::Rails::Engine
    ActiveJob::Base.send :include, BatChi::Batchable::Base
  end
end
