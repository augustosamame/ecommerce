class SendReferralProgramEmailWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.referral_program_email(user).deliver! #unless Rails.env == "development"
  end
end
