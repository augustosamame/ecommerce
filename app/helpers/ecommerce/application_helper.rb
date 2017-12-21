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

    def body_class
      [controller_name, action_name].join('-')
    end

  end
end
