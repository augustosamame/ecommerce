class CreateJoinTableProductsCoupons < ActiveRecord::Migration[5.2]
  def change
    create_join_table :products, :coupons do |t|
      t.references :product
      t.references :coupon
    end
  end
end
