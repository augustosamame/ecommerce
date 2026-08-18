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

  # retry: false — the groundhog-day reschedule below IS the retry cadence.
  # Sidekiq retries only duplicated the loop and reported every network
  # failure of the dead-man's-switch ping to Rollbar (which defeats the
  # point: the ping target going down must not page through Rollbar).
  sidekiq_options queue: queue_name, retry: false

  def perform
    if ENV['ROLLBAR_ENV'] == 'production'
      #return unless url = self.class.snitch_url
      #Net::HTTP.get(URI(url))

      begin
        url2 = "https://api.IsItWorking.info/c/ukcukscvpf"
        Net::HTTP.get(URI(url2))
      rescue StandardError => e
        # api.IsItWorking.info has been failing DNS resolution; a monitoring
        # ping must never raise (that's what the monitor's own alerting is
        # for). Log and keep the loop alive so pings resume if it returns.
        logger.warn("[SnitchWorker] ping failed: #{e.class}: #{e.message}")
      end

      # groundhog day!
      tot_snitch_jobs = Sidekiq::ScheduledSet.new.count { |x| x.klass == "SnitchWorker" }
      SnitchWorker.perform_in(5.minutes) unless tot_snitch_jobs > 2
      SnitchWorker.perform_in(2.minutes) unless tot_snitch_jobs > 4
    end
  end
end
