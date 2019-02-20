class CreateEcommercePricelists < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_pricelists do |t|
      t.string :name
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
