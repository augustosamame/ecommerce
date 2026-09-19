# The GlobalCanasta home hero has one fixed text block (pre-header, title,
# description, in ES and EN) edited under Backoffice → Controls. Seed the
# six controls with the storefront's default copy so they show up ready to edit.
class AddHomeHeroControls < ActiveRecord::Migration[7.0]
  DEFAULTS = {
    "home_hero_pre_header_es"  => ["Home hero: pre-header (ES)",  "Importando desde el 2018 · Lima, Perú"],
    "home_hero_pre_header_en"  => ["Home hero: pre-header (EN)",  "Importing since 2018 · Lima, Perú"],
    "home_hero_title_es"       => ["Home hero: title (ES)",       "Lo mejor del mundo,\nahora en Perú."],
    "home_hero_title_en"       => ["Home hero: title (EN)",       "The world's best,\nnow in Perú."],
    "home_hero_description_es" => ["Home hero: description (ES)", "Productos importados de todo el mundo a precio de origen. Stock inmediato en Lima, en tu puerta al día siguiente."],
    "home_hero_description_en" => ["Home hero: description (EN)", "Imported products from around the world at origin price. In stock in Lima, at your door the next day."]
  }.freeze

  def up
    DEFAULTS.each do |name, (label, value)|
      next if Ecommerce::Control.where(name: name).exists?
      Ecommerce::Control.create!(name: name, localized_name: label, value_field_type: "text", text_value: value)
    end
  end

  def down
    Ecommerce::Control.where(name: DEFAULTS.keys).delete_all
  end
end
