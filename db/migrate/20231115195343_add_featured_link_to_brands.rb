class AddFeaturedLinkToBrands < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_brands, :featured_link, :string
  end
end
