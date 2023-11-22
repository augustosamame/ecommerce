class AddBestSellerToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_products, :show_callout, :boolean
    add_column :ecommerce_products, :callout_label_en, :string
    add_column :ecommerce_products, :callout_label_es, :string
    add_column :ecommerce_products, :callout_discount, :integer
  end
end
