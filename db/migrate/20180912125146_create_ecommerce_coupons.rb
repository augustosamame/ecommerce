class CreateEcommerceCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_coupons do |t|
      t.string :coupon_code
      t.integer :coupon_type
      t.integer :dicount_percentage
      t.integer :discount_fixed
      t.decimal :discount_threshold, precision: 7, scale: 2
      t.datetime :start_date
      t.datetime :end_date
      t.integer :max_uses_per_user
      t.integer :max_uses
      t.integer :current_uses
      t.boolean :free_shipping
      t.integer :status

      t.timestamps
    end
  end
end
