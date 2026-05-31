class SplitActiveOnEcommerceFreeProducts < ActiveRecord::Migration[5.2]
  def up
    add_column :ecommerce_free_products, :web_active, :boolean, default: false, null: false
    add_column :ecommerce_free_products, :app_active, :boolean, default: false, null: false

    # Backfill: the single-platform `active` flag we shipped earlier today is
    # treated as web-only since the only flow wired so far was the web cart.
    execute("UPDATE ecommerce_free_products SET web_active = active")

    remove_column :ecommerce_free_products, :active
  end

  def down
    add_column :ecommerce_free_products, :active, :boolean, default: false, null: false
    execute("UPDATE ecommerce_free_products SET active = (web_active OR app_active)")
    remove_column :ecommerce_free_products, :web_active
    remove_column :ecommerce_free_products, :app_active
  end
end
