class CreateEcommerceUserAudiences < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_user_audiences do |t|
      t.references :user
      t.references :audience
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
