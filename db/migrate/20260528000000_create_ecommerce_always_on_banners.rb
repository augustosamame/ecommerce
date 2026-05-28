class CreateEcommerceAlwaysOnBanners < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_always_on_banners do |t|
      t.text :message_en
      t.text :message_es
      t.string :link_url
      t.boolean :web_enabled, default: true, null: false
      t.boolean :app_enabled, default: true, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
