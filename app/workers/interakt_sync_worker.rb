class SendBackInStockWorker
  include Sidekiq::Worker

  def perform(user_id)
    Interakt.new.track_user({ user_id: user_id })
  end
end
