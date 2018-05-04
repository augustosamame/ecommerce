class AddEcommerceFeaturedToBrands < ActiveRecord::Migration[5.1]
  def change
    add_column :ecommerce_brands, :featured, :boolean, default: false
  end
end
