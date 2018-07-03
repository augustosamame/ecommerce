# This migration comes from ecommerce (originally 20180628132313)
class CreateEcommerceDataBizInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_data_biz_invoices do |t|
      t.references :user
      t.string :vat
      t.text :address
      t.string :city
      t.string :ubigeo

      t.timestamps
    end
    add_foreign_key :ecommerce_data_biz_invoices, :users, column: :user_id
  end
end
