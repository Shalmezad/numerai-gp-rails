module BatChi
  def self.batch
    Batch.new
  end

  class Batch
    NEXT_AVAILABLE_BATCH_ID_KEY="BatChi:next_available_batch_id"

    def self.batch_count_key(batch_id)
      "BatChi:batch_#{batch_id}_job_count"
    end

    def self.redis
      # TODO: Eventually have our own redis:
      return Resque.redis
    end

    def initialize
      # Need to get the next available batch id:
      @batch_id = Batch.redis.incr(NEXT_AVAILABLE_BATCH_ID_KEY)
      @batch_jobs = []
      @batch_callback = nil
    end

    def callback(clazz, *args)
      @batch_callback = {}
      @batch_callback[:clazz] = clazz.to_s
      @batch_callback[:args] = args
    end

    def add(clazz, *args)
      batch_job = {}
      batch_job[:clazz] = clazz
      batch_job[:args] = args
      @batch_jobs << batch_job
    end

    def start
      # Alright, we need to:
      # 1) Set up our job counter:
      Batch.redis.set(Batch.batch_count_key(@batch_id), @batch_jobs.count)
      # 2) Set up and start the jobs:
      @batch_jobs.each do |batch_job|
        args = batch_job[:args]
        # Add our callback
        args.unshift @batch_callback
        # Add our batch id
        args.unshift @batch_id
        # Add the batched job key:
        args.unshift BatChi::IS_A_BATCHED_JOB_KEY
        batch_job[:clazz].perform_later(*args)
      end
    end
  end

end
