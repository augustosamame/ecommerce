class CreateEcommerceProofOfDeliveryImages < ActiveRecord::Migration[7.0]
  def change
    create_table :ecommerce_proof_of_delivery_images do |t|
      t.references :user, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: { to_table: :ecommerce_orders }
      t.string :proof_of_delivery, null: false
      t.timestamps
    end

    add_index :ecommerce_proof_of_delivery_images, [:order_id, :created_at]
    add_index :ecommerce_proof_of_delivery_images, [:user_id, :created_at]
  end
end