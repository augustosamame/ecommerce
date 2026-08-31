class AddCurrencyToEcommercePayments < ActiveRecord::Migration[7.0]
  # Currency the charge was actually made in ("pen"/"usd"). The order itself
  # is stored in USD by the web checkout, so without this the paid currency
  # was unrecoverable — and soles-paid orders must be invoiced in soles at
  # the website rate they were charged. Legacy rows stay NULL (treated USD).
  def change
    add_column :ecommerce_payments, :currency, :string
  end
end
