class AddSliderLinkToSliders < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_sliders, :slider_link, :string
  end
end
