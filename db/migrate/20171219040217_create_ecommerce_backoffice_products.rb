class CreateEcommerceBackofficeProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_backoffice_products do |t|
      t.string :name
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
