class CreateEcommerceCards < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_cards do |t|
      t.references :user, foreign_key: true
      t.string :processor_token
      t.string :payment_email
      t.string :number
      t.string :bin
      t.string :last_four
      t.string :brand
      t.string :card_type
      t.string :card_category
      t.string :issuer_name
      t.string :issuer_country_code
      t.integer :status

      t.timestamps
    end
  end
end
