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

  end
end
