require_dependency "ecommerce/application_controller"

module Ecommerce
  class ProductFeedController < ActionController::API

    # GET /store/feed/products.json
    # Public, read-only product feed for bots and integrations
    def index
      products = Ecommerce::Product.includes(:translations, :brand, :category)
                                    .active
                                    .order(:product_order)

      if params[:category_id].present?
        category = Ecommerce::Category.find_by(id: params[:category_id])
        if category
          Globalize.with_locale(Ecommerce.backoffice_default_locale) do
            products = products.tagged_with(category.name)
          end
        end
      end

      page = (params[:page] || 1).to_i
      per_page = [(params[:per_page] || 50).to_i, 100].min
      products = products.page(page).per(per_page)

      rate = Ecommerce::Control.get_control_value("exchange_rate").to_f

      feed = {
        store: {
          name: Ecommerce.site_name,
          url: "https://expatshop.pe",
          currency_primary: "USD",
          currency_secondary: "PEN",
          exchange_rate_usd_to_pen: rate,
          stock_policy: "All products are in stock unless explicitly marked as out of stock.",
          updated_at: Time.current.iso8601
        },
        meta: {
          current_page: products.current_page,
          total_pages: products.total_pages,
          total_count: products.total_count,
          per_page: per_page
        },
        products: products.map do |product|
          usd_price = product.discounted_price.to_f
          usd_regular = product.price.to_f
          {
            id: product.id,
            sku: product.id.to_s,
            slug: product.permalink,
            url: "https://expatshop.pe/store/products/#{product.permalink}",
            name_en: product.name_en_pe,
            name_es: product.name_es_pe,
            description_en: product.description_en_pe&.gsub("**", " ")&.strip,
            description_es: product.description_es_pe&.gsub("**", " ")&.strip,
            brand: product.brand&.name,
            categories: product.translated_category_list,
            image_url: product.image.url,
            price_usd: usd_price,
            price_pen: (usd_price * rate).round(2),
            regular_price_usd: usd_regular,
            regular_price_pen: (usd_regular * rate).round(2),
            on_sale: product.discounted?,
            in_stock: product.in_stock?,
            weight_grams: product.weight,
            updated_at: product.updated_at.iso8601
          }
        end
      }

      expires_in 1.hour, public: true
      render json: feed
    end
  end
end
