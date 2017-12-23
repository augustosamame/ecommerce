class CreateEcommerceControls < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_controls do |t|
      t.string :name
      t.string :localized_name
      t.string :value_field_type
      t.boolean :internal, default: false
      t.text :text_value
      t.integer :integer_value
      t.float :float_value
      t.boolean :boolean_value
      t.datetime :date_value

      t.timestamps
    end
  end
end
