class AddEditorialFieldsToEcommerceSliders < ActiveRecord::Migration[7.0]
  # Optional editorial copy for the GlobalCanasta hero carousel: pre-header,
  # title, description and two CTAs (text ES/EN + url). A slide with none of
  # these renders media-only, full width. Banner 1 (lowest order) supplies
  # only its media — its copy is fixed in the storefront locale files.
  def change
    change_table :ecommerce_sliders, bulk: true do |t|
      t.string :pre_header_es
      t.string :pre_header_en
      t.string :title_es
      t.string :title_en
      t.text   :description_es
      t.text   :description_en
      t.string :cta1_text_es
      t.string :cta1_text_en
      t.string :cta1_url
      t.string :cta2_text_es
      t.string :cta2_text_en
      t.string :cta2_url
    end
  end
end
