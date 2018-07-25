class AddRazonSocialToDataBizInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_data_biz_invoices, :razon_social, :string
  end
end
