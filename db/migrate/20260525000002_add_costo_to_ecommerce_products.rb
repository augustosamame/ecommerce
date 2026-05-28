class AddCostoToEcommerceProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :ecommerce_products, :costo_cents, :integer, default: 0
  end
end
