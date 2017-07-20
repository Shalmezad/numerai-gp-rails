module JobProf
  module Profable
    module Base
      def self.included(base)
        base.send :extend, ClassMethods
      end

      module ClassMethods
        PROF_JOB_ID_KEY = "JobProf_Job_Id_key"
        def profable
          self.prepend PrependMethods
        end

        module PrependMethods
          def perform(*args)
            @prof_id = Resque.redis.incr(PROF_JOB_ID_KEY)
            RubyProf.start
            super(*args)
            results = RubyProf.stop
            File.open "#{Rails.root}/tmp/performance/#{@prof_id}-stack.html", 'w' do |file|
              RubyProf::CallStackPrinter.new(results).print(file)
            end
          end
        end
      end

    end
  end
end
