class AddExtraFieldsToCoupons < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_coupons, :always_on_active, :boolean, default: false
    add_column :ecommerce_coupons, :always_on_start_date, :datetime
    add_column :ecommerce_coupons, :always_on_end_date, :datetime
    add_column :ecommerce_coupons, :always_on_message_en, :text
    add_column :ecommerce_coupons, :always_on_message_es, :text
    add_column :ecommerce_coupons, :minimum_quantity_applies, :boolean, default: false
    add_column :ecommerce_coupons, :minimum_quantity, :integer, default: 0
    add_column :ecommerce_coupons, :minimum_quantity_product, :integer, default: 0
    add_column :ecommerce_coupons, :combo_applies, :boolean, default: false
    add_column :ecommerce_coupons, :combo_products, :text, array: true, default: []
    add_column :ecommerce_coupons, :coupon_terms_en, :text
    add_column :ecommerce_coupons, :coupon_terms_es, :text
  end
end
