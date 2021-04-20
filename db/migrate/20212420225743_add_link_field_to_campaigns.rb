class AddLinkFieldToCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_campaigns, :link, :string
  end
end
