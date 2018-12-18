class SnitchWorker
  include Sidekiq::Worker
  require 'sidekiq/api'

  def self.snitch_url
    ENV['SIDEKIQ_SNITCH_URL']
  end

  def self.queue_name
    # Extract the snitch token from the snitch url
    # and use it to name the queue
    token = snitch_url ? snitch_url.split("/").last : 'q'
    ['snitch', token].join('_')
  end

  sidekiq_options queue: queue_name

  def perform
    if ENV['ROLLBAR_ENV'] == 'production'
      return unless url = self.class.snitch_url
      #Net::HTTP.get(URI(url))

      url2 = "https://api.IsItWorking.info/c/ukcukscvpf"
      Net::HTTP.get(URI(url2))

      # groundhog day!
      tot_snitch_jobs = Sidekiq::ScheduledSet.new.count { |x| x.klass == "SnitchWorker" }
      SnitchWorker.perform_in(5.minutes) unless tot_snitch_jobs > 2
    end
  end
end
