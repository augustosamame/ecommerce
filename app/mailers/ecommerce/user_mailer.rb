module Ecommerce
  class UserMailer < ApplicationMailer
    add_template_helper(Ecommerce::ApplicationHelper)
    default from: "ExpatShop.pe <gg@expatshop.pe>", bcc: ["gg@expatshop.pe", "aniruddhasac@gmail.com", "augusto@devtechperu.com"]

    def welcome_email(user)
      @user = user
      @url  = "https://#{ActionMailer::Base.default_url_options[:host]}/users/sign_in"
      mail(to: @user.email, subject: t('.subject'))
    end

    def new_order_email(user, order)
      @user = user
      @order = order
      mail(to: @user.email, subject: t('.subject'))
    end

    def next_order_coupon_email(user, order, coupon, campaign)
      @user = user
      @order = order
      @coupon = coupon
      @campaign = campaign
      @coupon_description_en = @campaign.email_coupon_description
      @coupon_description_es = @campaign.email_coupon_description_es
      coupon_subject = I18n.locale == ':es-PE' ? @campaign.email_subject_es : @campaign.email_subject
      mail(to: @user.email, subject: coupon_subject)
    end

    def send_campaign_email(user, coupon, campaign)
      @user = user
      @coupon = coupon
      @campaign = campaign
      email_subject = I18n.locale == ':es-PE' ? @campaign.email_subject_es : @campaign.email_subject
      mail(to: @user.email, subject: email_subject)
    end

    def order_paid(user, order)
      @user = user
      @order = order
      mail(to: @user.email, subject: t('.subject'))
    end

    def update_to_paid_email(user, order)
      @user = user
      @order = order
      mail(to: @user.email, subject: t('.subject'))
    end

end
end
