class AddBestSellerFieldsToProducts < ActiveRecord::Migration[5.2]
  def change
    
    add_column :ecommerce_products, :callout_discount_label_en, :string
    add_column :ecommerce_products, :callout_discount_label_es, :string
  end
end
