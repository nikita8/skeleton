module BackgroundJobs
  module Regular
    class SampleBgJob
      include Sidekiq::Worker
      # code here
    end
  end
end
