module BackgroundJobs
  module Regular
    # :nodoc:
    class SampleBgJob
      include Sidekiq::Worker
      # code here
    end
  end
end
