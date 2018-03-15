class AddEcommerceDescription2ToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :ecommerce_products, :description2, :string
  end
end
