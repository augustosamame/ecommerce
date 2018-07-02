class AddEcommerceFieldsToPaymentMethods < ActiveRecord::Migration[5.1]
  def change
    add_column :ecommerce_payment_methods, :processor, :string
    add_column :ecommerce_payment_methods, :account, :string
    add_column :ecommerce_payment_methods, :key, :text
    add_column :ecommerce_payment_methods, :secret, :text
    add_column :ecommerce_payment_methods, :callback_url, :string
    add_column :ecommerce_payment_methods, :success_marks_as_paid, :boolean
    add_column :ecommerce_payment_methods, :logo, :string
    add_column :ecommerce_payment_methods, :pre_message, :text
    add_column :ecommerce_payment_methods, :post_message, :text
  end
end
