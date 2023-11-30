class AddDripFieldsToCampaigns < ActiveRecord::Migration[5.2]
  def change
    
    add_column :ecommerce_campaigns, :drip_product_id, :integer
    add_column :ecommerce_campaigns, :drip_base_coupon_id, :integer
    add_column :ecommerce_campaigns, :drip_days_after, :integer
  end
end
