module Ecommerce
  # View helpers for the GlobalCanasta storefront (globalcanasta theme).
  module GlobalcanastaHelper
    ICONS = {
      search:   '<circle cx="11" cy="11" r="7"/><path d="M20 20l-3.5-3.5"/>',
      cart:     '<path d="M6 7h14l-1.5 8h-11z"/><path d="M6 7L5 3H2"/><circle cx="9" cy="20" r="1.2"/><circle cx="17" cy="20" r="1.2"/>',
      bag:      '<path d="M5 8h14l-1 12H6z"/><path d="M9 8V6a3 3 0 0 1 6 0v2"/>',
      heart:    '<path d="M12 20s-7-4.6-7-10a4 4 0 0 1 7-2.5A4 4 0 0 1 19 10c0 5.4-7 10-7 10z"/>',
      user:     '<circle cx="12" cy="8" r="4"/><path d="M4 20a8 8 0 0 1 16 0"/>',
      menu:     '<path d="M4 7h16M4 12h16M4 17h16"/>',
      close:    '<path d="M6 6l12 12M18 6L6 18"/>',
      whatsapp: '<path d="M4 20l1.2-4A8 8 0 1 1 8.2 19z"/><path d="M9.5 9.5c0 3 2 5 5 5l1-1.5-2-1-1 1a4 4 0 0 1-1.5-1.5l1-1-1-2z"/>',
      phone:    '<path d="M5 4h4l2 5-2.5 1.5a11 11 0 0 0 5 5L15 13l5 2v4a2 2 0 0 1-2 2A16 16 0 0 1 3 6a2 2 0 0 1 2-2z"/>',
      play:     '<path d="M8 5v14l11-7z"/>',
      chevron_down: '<path d="M6 9l6 6 6-6"/>',
      chevron_right: '<path d="M9 6l6 6-6 6"/>',
      chevron_left: '<path d="M15 6l-6 6 6 6"/>',
      check:    '<path d="M5 12l5 5L20 7"/>',
      trash:    '<path d="M4 7h16M10 11v6M14 11v6M6 7l1 13h10l1-13M9 7V4h6v3"/>',
      plus:     '<path d="M12 5v14M5 12h14"/>',
      minus:    '<path d="M5 12h14"/>',
      filter:   '<path d="M4 6h16M7 12h10M10 18h4"/>',
      instagram: '<rect x="4" y="4" width="16" height="16" rx="4"/><circle cx="12" cy="12" r="3.5"/><circle cx="17" cy="7" r=".8"/>',
      facebook: '<path d="M14 8h2V5h-2a3 3 0 0 0-3 3v2H9v3h2v7h3v-7h2l1-3h-3V8z"/>',
      youtube:  '<rect x="3" y="6" width="18" height="12" rx="3"/><path d="M10 9.5v5l4.5-2.5z"/>',
      star:     '<path d="M12 3l2.7 5.6 6.1.9-4.4 4.3 1 6.1L12 17l-5.4 2.9 1-6.1L3.2 9.5l6.1-.9z"/>',
      point:    '<circle cx="12" cy="12" r="8"/><path d="M12 8v4l2.5 2"/>',
      gift:     '<rect x="4" y="10" width="16" height="10" rx="1"/><path d="M4 10h16v-3H4zM12 7v13M12 7c-2-4-6-3-4 0M12 7c2-4 6-3 4 0"/>',
      truck:    '<path d="M3 7h11v9H3zM14 10h4l3 3v3h-7z"/><circle cx="7" cy="17" r="1.5"/><circle cx="17" cy="17" r="1.5"/>',
      box:      '<path d="M4 8l8-4 8 4v8l-8 4-8-4z"/><path d="M4 8l8 4 8-4M12 12v8"/>',
      file:     '<path d="M6 3h8l4 4v14H6z"/><path d="M14 3v4h4"/>',
      arrow_right: '<path d="M5 12h14M13 6l6 6-6 6"/>',
      eye:      '<path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/>',
      diamond:  '<path d="M12 3l9 9-9 9-9-9z" fill="currentColor" stroke="none"/>',
      globe:    '<circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3a14 14 0 0 1 0 18M12 3a14 14 0 0 0 0 18"/>',
      map_pin:  '<path d="M12 21s6-5.5 6-11a6 6 0 0 0-12 0c0 5.5 6 11 6 11z"/><circle cx="12" cy="10" r="2"/>',
      settings: '<circle cx="12" cy="12" r="3"/><path d="M12 2v3M12 19v3M2 12h3M19 12h3M4.9 4.9l2.1 2.1M17 17l2.1 2.1M4.9 19.1L7 17M17 7l2.1-2.1"/>',
      logout:   '<path d="M10 4H5v16h5M14 8l4 4-4 4M18 12H9"/>'
    }.freeze

    # Inline stroke icon. `size` in px; colour follows `currentColor`.
    def gc_icon(name, size: 18, css: nil, label: nil)
      paths = ICONS.fetch(name.to_sym)
      opts = { width: size, height: size, viewBox: "0 0 24 24", fill: "none", stroke: "currentColor",
               "stroke-width" => 1.75, "stroke-linecap" => "round", "stroke-linejoin" => "round",
               class: ["gc-icon", css].compact.join(" ") }
      if label
        opts[:role] = "img"
        opts["aria-label"] = label
      else
        opts["aria-hidden"] = "true"
        opts[:focusable] = "false"
      end
      content_tag(:svg, paths.html_safe, opts)
    end

    # Official WhatsApp glyph (Simple Icons path, CC0) in brand green — the
    # stroked :whatsapp icon above is for monochrome contexts.
    WHATSAPP_LOGO_PATH = "M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.885-9.885 9.885m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413Z".freeze

    def gc_whatsapp_logo(size: 24, css: nil)
      content_tag(:svg, %(<path d="#{WHATSAPP_LOGO_PATH}"/>).html_safe,
                  width: size, height: size, viewBox: "0 0 24 24", fill: "#25D366",
                  class: ["gc-icon", "gc-icon--whatsapp", css].compact.join(" "),
                  "aria-hidden" => "true", focusable: "false")
    end

    # New wordmark. logo.png is the client JPEG comp with its white box keyed
    # out (see logo.jpeg for the original); replace with the SVG when supplied.
    def gc_logo(height: 44, css: nil, alt: "GlobalCanasta")
      image_tag "ecommerce/img/globalcanasta/logo.png", alt: alt,
                class: ["gc-logo", css].compact.join(" "), style: "height:#{height}px;"
    end

    # Category name in the current locale, falling back to any translation
    # (imported/legacy categories often only carry Spanish).
    def gc_category_name(category)
      name = category.name.presence
      return name if name
      if category.respond_to?(:translations)
        translated = category.translations.map(&:name).compact.map(&:presence).compact.first
        return translated if translated
      end
      category.read_attribute(:name).presence || "—"
    end

    def gc_brand_name
      "GlobalCanasta"
    end

    def gc_whatsapp_url
      "https://wa.me/51989080023"
    end

    # Cart/order amounts are stored in USD. Returns [primary, secondary]
    # formatted strings following the session currency (PEN first by default).
    def gc_money_pair(usd_value)
      rate = (@exchange_rate || Ecommerce::Control.get_control_value("exchange_rate") || 3.8).to_f
      usd = usd_value.to_f
      pen_str = "S/ #{number_with_precision(usd * rate, precision: 2, delimiter: ',')}"
      usd_str = "USD $ #{number_with_precision(usd, precision: 2, delimiter: ',')}"
      session[:currency] == "usd" ? [usd_str, pen_str] : [pen_str, usd_str]
    end

    # Localised text without falling back to the translation-missing span
    def gc_t(key, default)
      t(key, default: default)
    end

    # Percentage saved between list price and discounted price, or nil.
    def gc_discount_pct(product)
      return nil if product.price.blank? || product.discounted_price.blank?
      return nil if product.price.to_f <= 0 || product.price == product.discounted_price
      pct = ((1 - product.discounted_price.to_f / product.price.to_f) * 100).round
      pct > 0 ? pct : nil
    end

    # Product origin for the card eyebrow: country of origin, else brand.
    def gc_product_origin(product)
      country = product.try(:country)
      return country if country.present?
      product.try(:brand).try(:name)
    rescue StandardError
      nil
    end
  end
end
