class AddEmailFieldsToCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_campaigns, :email_subject, :string
    add_column :ecommerce_campaigns, :email_subject_es, :string
    add_column :ecommerce_campaigns, :email_coupon_description, :text
    add_column :ecommerce_campaigns, :email_coupon_description_es, :text
    add_column :ecommerce_campaigns, :image, :text
  end
end
