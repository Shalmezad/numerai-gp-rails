#require File.dirname(__FILE__) + "/jobprof"
require File.dirname(__FILE__) + "/profable"

module JobProf

  class Engine < ::Rails::Engine
    ActiveJob::Base.send :include, JobProf::Profable::Base
  end
end
