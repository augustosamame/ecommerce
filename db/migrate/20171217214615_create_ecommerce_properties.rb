class CreateEcommerceProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_properties do |t|
      t.string      :identifing_name, :null => false
      t.string      :display_name
      t.boolean     :active,          :default => true

      t.timestamps
    end
  end
end
