module Ecommerce
  module ApplicationHelper

    def friendly_date(date)
      case
      when date > 60.minutes.ago
        minutes = ((Time.now - date) / 60).round(0)
        return "Hace #{minutes} minutos"
      when date > 48.hours.ago
        hours = ((Time.now - date) / 3600).round(0)
        return "Hace #{hours} horas"
      when date <= 2.days.ago
        days = ((Time.now - date) / (3600 * 24)).round(0)
        return "Hace #{days} días"
      else
        return date
      end
    end

    def body_css_class
      @body_css_classes ||= []
      view_css_class = [controller_name, action_name].join('-')

      @body_css_classes.unshift(view_css_class).join(' ')
    end

    def get_default_language_from_session
      case session[:locale] || I18n.default_locale
        when "es-PE"
          return "Español"
        when "en-PE"
          return "English"
        else
          return "Español"
      end
    end

    def session_currency_symbol
      case session[:currency]
      when "pen"
          return "$ "
        when "usd"
          return "$ "
        else
          return "$ "
      end
    end

    def session_currency(value)
      case session[:currency]
      when "pen"
        return number_to_currency(value, locale: "en-PE")
      when "usd"
        return number_to_currency(value, locale: "en-US")
      else
        return number_to_currency(value, locale: "en-PE")
      end
    end

    def session_price(amount, field = nil)
      case session[:currency]
      when "pen"
        value = field ? eval("amount.#{field}") : amount
        return number_to_currency(value, locale: "en-PE")
      when "usd"
        value = field ? eval("amount.usd_#{field}") : amount
        return number_to_currency(value, locale: "en-US")
      else
        value = field ? eval("amount.#{field}") : amount
        return number_to_currency(value, locale: "en-PE")
      end
    end

    def flash_class(level)
      case level.to_sym
        # allow either standard rails flash category symbols...
        when :notice then "info"
        when :success then "success"
        when :alert then "warning"
        when :error then "danger"
        # ... or bootstrap class symbols
        when :info then "info"
        when :warning then "warning"
        when :danger then "danger"
        # and default to being alarming
        else "danger"
      end
    end

    def cookie_string_to_hash(mycookie)
      hash = {}
        if mycookie
        array = mycookie.split(',')


          array.each do |e|
            key_value = e.split('=')
            hash[key_value[0]] = key_value[1]
          end
        end
      return hash
    end

    def col_width_for_image_dimensions(category)
      ratio = category.homepage_cat_image_width / category.homepage_cat_image_height
      puts ratio
      case
      when ratio < 1.2
        return "3"
      when ratio < 1.4
        return "4"
      when ratio < 1.7
        return "5"
      else
        return "6"
      end
    end

    def friendly_payment_stage(passed_payment_stage)
      case passed_payment_stage
      when "paid"
        return t('model.order.payment_stage_paid')
      when "unpaid"
        return t('model.order.payment_stage_unpaid')
      when "refunded"
        return t('model.order.payment_stage_refunded')
      when "void"
        return t('model.order.payment_stage_void')
      end
    end

    def friendly_delivery_window(order_time)
      if order_time < Time.new((Time.now - 5.hours).year, (Time.now - 5.hours).month, (Time.now - 5.hours).day, 11, 30)
        return t('model.order.today_afternoon')
      else
        return t('model.order.tomorrow_afternoon')
      end

    end

  end
end
