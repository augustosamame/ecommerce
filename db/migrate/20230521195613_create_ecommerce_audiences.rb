class CreateEcommerceAudiences < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_audiences do |t|
      t.string :audience_name, null: false
      t.string :audience_description
      t.integer :audience_type, default: 0
      t.integer :user_total, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
