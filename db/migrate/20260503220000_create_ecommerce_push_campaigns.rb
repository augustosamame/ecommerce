class CreateEcommercePushCampaigns < ActiveRecord::Migration[7.0]
  def change
    create_table :ecommerce_push_campaigns do |t|
      t.string :name
      t.integer :campaign_type, default: 1
      t.integer :status, default: 0
      t.integer :coupon_id
      t.integer :audience_id
      t.string :title
      t.string :title_es
      t.text :body
      t.text :body_es
      t.string :deep_link
      t.timestamps
    end

    add_index :ecommerce_push_campaigns, :coupon_id
    add_index :ecommerce_push_campaigns, :audience_id
  end
end
