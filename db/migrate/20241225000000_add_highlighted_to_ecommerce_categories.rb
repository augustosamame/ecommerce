class AddHighlightedToEcommerceCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :ecommerce_categories, :highlighted, :boolean, default: false, null: false
  end
end