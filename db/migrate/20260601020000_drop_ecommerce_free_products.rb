class DropEcommerceFreeProducts < ActiveRecord::Migration[5.2]
  # The Free Product feature is being refactored into a coupon_type
  # ("free_product") on the existing Ecommerce::Coupon model. The standalone
  # ecommerce_free_products table (and its companion columns added in
  # 20260601000000 and 20260601010000) is no longer needed. Those earlier
  # migrations stay on disk because they were already applied in production;
  # this one undoes them by dropping the table.
  def up
    drop_table :ecommerce_free_products if table_exists?(:ecommerce_free_products)
  end

  def down
    create_table :ecommerce_free_products do |t|
      t.bigint :product_id
      t.boolean :web_active, default: false, null: false
      t.boolean :app_active, default: false, null: false
      t.timestamps
    end
    add_index :ecommerce_free_products, :product_id
  end
end
