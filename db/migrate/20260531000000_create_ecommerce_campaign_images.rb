class CreateEcommerceCampaignImages < ActiveRecord::Migration[5.2]
  def up
    create_table :ecommerce_campaign_images do |t|
      t.references :campaign, null: false, foreign_key: { to_table: :ecommerce_campaigns }
      t.string :image
      t.string :link
      t.integer :position, default: 0, null: false

      t.timestamps
    end

    # Backfill: each existing campaign with a legacy image/link becomes one
    # CampaignImage row. After this migration the form no longer surfaces
    # the legacy `image`/`link` columns; rendering goes through campaign_images.
    say_with_time "Backfilling campaign_images from legacy campaign.image/link" do
      execute(<<~SQL)
        INSERT INTO ecommerce_campaign_images (campaign_id, image, link, position, created_at, updated_at)
        SELECT id, image, link, 0, NOW(), NOW()
        FROM ecommerce_campaigns
        WHERE image IS NOT NULL AND image <> ''
      SQL
    end
  end

  def down
    drop_table :ecommerce_campaign_images
  end
end
