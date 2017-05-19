module BatChi
  module Batchable
    module Base
      def self.included(base)
        Rails.logger.warn "Batchi batchable included"
        base.send :extend, ClassMethods
      end

      module ClassMethods
        def batchable
          Rails.logger.warn "Batchi batchable"
          self.prepend PrependMethods
          self.include InstanceMethods
          self.after_perform do |job|
            if !job.batchi_batch_id.nil?
              result = BatChi::Batch::redis.decr(BatChi::Batch::batch_count_key(job.batchi_batch_id))
              Rails.logger.warn "#{result} jobs left"
              if result <= 0
                Rails.logger.warn "Calling callback!"
                callback = job.batchi_batch_callback
                clazz = callback[:clazz].constantize
                args = callback[:args]
                clazz.perform_later(args)
              end
            else
              Rails.logger.warn "No batch..."
            end
          end

        end
      end

      module PrependMethods
        def perform(*args)
          Rails.logger.warn "Batchi batchable perform"
          # Do we have the # of args?
          if args.size < 2
            Rails.logger.warn "Batchi batchable args too small"
            super(args)
          else  
            # Ok, but are they OUR args?
            if args.first == BatChi::IS_A_BATCHED_JOB_KEY
              # Yay!
              Rails.logger.warn "Batchi job detected"
              key = args.shift
              @batchi_batch_id = args.shift
              @batchi_batch_callback = args.shift
              super(args)
            else
              Rails.logger.warn "Batchi batchable not key"
              super(args)
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
