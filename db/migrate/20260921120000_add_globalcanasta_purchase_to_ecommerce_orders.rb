# Orders placed through the GlobalCanasta domains (or the GlobalCanasta app)
# are flagged so sales per brand can be reported and so their emails go out
# under the GlobalCanasta name and domain.
class AddGlobalcanastaPurchaseToEcommerceOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :ecommerce_orders, :globalcanasta_purchase, :boolean, default: false, null: false
    add_index :ecommerce_orders, :globalcanasta_purchase
  end
end
