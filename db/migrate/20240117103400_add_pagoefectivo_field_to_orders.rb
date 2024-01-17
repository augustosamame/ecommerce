class AddPagoefectivoFieldToOrders < ActiveRecord::Migration[5.2]
  def change
    
    add_column :ecommerce_orders, :pagoefectivo_cip, :string
    add_column :ecommerce_orders, :pagoefectivo_exp_date, :string
    add_column :ecommerce_orders, :pagoefectivo_qr_code, :string
  end
end
