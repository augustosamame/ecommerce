class SendExpoPushWorker
  include Sidekiq::Worker

  def perform(user_id, title, body, data = {})
    user = User.find_by(id: user_id)
    return unless user
    return if user.expo_push_token.blank?

    ExpoPush.new.send_notification({
      user_id: user_id,
      title: title,
      body: body,
      data: data
    })
  end
end
