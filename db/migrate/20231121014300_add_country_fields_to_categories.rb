class AddCountryFieldsToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_categories, :mosaic_show, :boolean
    add_column :ecommerce_categories, :mosaic_label_en, :string
    add_column :ecommerce_categories, :mosaic_label_es, :string
  end
end
