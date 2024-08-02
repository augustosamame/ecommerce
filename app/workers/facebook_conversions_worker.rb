class FacebookConversionsWorker
  include Sidekiq::Worker

  def perform(event, params)
    FacebookApi.new.send_event(event, params)
  end
end
