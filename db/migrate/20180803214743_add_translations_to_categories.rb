class AddTranslationsToCategories < ActiveRecord::Migration[5.2]
  def change

    reversible do |dir|

      dir.up do
        Ecommerce::Category.create_translation_table!( {:name => :string, :image_popular_homepage_overlay_text => :string}, {:migrate_data => true} )
      end

      dir.down do
        Ecommerce::Category.drop_translation_table! :migrate_data => true
      end

    end

  end
end
