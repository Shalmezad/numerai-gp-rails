module BatChi
  module Batchable
    module Base
      def self.included(base)
        base.send :extend, ClassMethods
      end

      module ClassMethods
        def batchable
          self.prepend PrependMethods
          self.include InstanceMethods
          self.after_perform do |job|
            if !job.batchi_batch_id.nil?
              result = BatChi::Batch::redis.decr(BatChi::Batch::batch_count_key(job.batchi_batch_id))
              if result <= 0
                callback = job.batchi_batch_callback
                clazz = callback[:clazz].constantize
                args = callback[:args]
                clazz.perform_later(*args)
              end
            else
              # No batch
            end
          end

        end
      end

      module PrependMethods
        def perform(*args)
          # Do we have the # of args?
          if args.size < 2
            super(*args)
          else  
            # Ok, but are they OUR args?
            if args.first == BatChi::IS_A_BATCHED_JOB_KEY
              # Yay!
              key = args.shift
              @batchi_batch_id = args.shift
              @batchi_batch_callback = args.shift
              super(*args)
            else
              super(*args)
            end
          end
        end
      end

      module InstanceMethods
        def batchi_batch_id
          @batchi_batch_id
        end
        def batchi_batch_callback
          @batchi_batch_callback
        end
      end

    end
  end
end
