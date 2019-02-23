class CreateEcommerceCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_campaigns do |t|
      t.references :coupon
      t.string :name
      t.integer :campaign_type, :default => 0
      t.integer :email_template_id
      t.integer :status, :default => 0

      t.timestamps
    end
  end
end
