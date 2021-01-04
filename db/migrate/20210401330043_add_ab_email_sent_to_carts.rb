class AddAbEmailSentToCarts < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_carts, :abandoned_email_sent, :boolean, default: true
  end
end
