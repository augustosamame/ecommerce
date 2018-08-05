class RemoveNullConstraintsFromResourceTranslations < ActiveRecord::Migration[5.2]
  def change
    change_column_null :ecommerce_categories, :name, true
    change_column_null :ecommerce_products, :name, true
  end
end
