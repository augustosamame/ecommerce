class AddEcommerceEfactFieldsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_orders, :efact_type, :integer, default: 0
    add_column :ecommerce_orders, :efact_number, :string
    add_column :ecommerce_orders, :efact_refund_number, :string
    add_column :ecommerce_orders, :efact_refund_url, :text
    add_column :ecommerce_orders, :efact_void_url, :text
  end
end
