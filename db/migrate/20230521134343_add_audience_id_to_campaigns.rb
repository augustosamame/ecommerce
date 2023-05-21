class AddAudienceIdToCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_campaigns, :audience_id, :integer
  end
end
