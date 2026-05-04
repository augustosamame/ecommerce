class SwapDeepLinkForTargetProductOnPushCampaigns < ActiveRecord::Migration[7.0]
  def change
    remove_column :ecommerce_push_campaigns, :deep_link, :string
    add_column :ecommerce_push_campaigns, :target_product_id, :integer
    add_index :ecommerce_push_campaigns, :target_product_id
  end
end
