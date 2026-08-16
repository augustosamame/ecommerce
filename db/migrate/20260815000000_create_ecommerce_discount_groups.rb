class CreateEcommerceDiscountGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_discount_groups do |t|
      t.string :name, null: false
      t.integer :status, default: 0, null: false
      # Last applied discount settings, kept so the apply form can pre-fill
      # and so the current bulk state is visible on the group.
      t.decimal :discount_percentage, precision: 5, scale: 2, default: 0, null: false
      t.boolean :discount_active, default: false, null: false
      t.datetime :last_applied_at

      t.timestamps
    end
    add_index :ecommerce_discount_groups, :name, unique: true

    add_column :ecommerce_products, :discount_group_id, :integer
    add_index :ecommerce_products, :discount_group_id
  end
end
