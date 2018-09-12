class AddEcommerceRequiredDocToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_orders, :required_doc, :string
  end
end
