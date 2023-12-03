  class Interakt
    include HTTParty
    base_uri (ENV["RUNTIME_ENV"] == 'production' ? 'https://api.interakt.ai/v1/public' : 'https://api.interakt.ai/v1/public')

    def initialize
      api_key = ENV['INTERAKT_API_KEY']
      @headers = {
        "Authorization": "Basic #{api_key}",
        "Content-Type": "application/json"
      }
    end

    def track_user(hash) #hash with key: user_id
      begin
        user = User.find(hash[:user_id])
        options = {
          userId: user.id,
          fullPhoneNumber: user.normalized_phone,
          traits: calculate_traits(user),
          tags: calculate_tags(user)
        }
        call_options = {
          headers: @headers,
          body: options.to_json,
        }
        response = self.class.post("/track/users/", call_options)
        if response.code == 200 || response.code == 202
          return response.parsed_response
        else
          return {error: "Code: #{response.code.to_s} - #{response.try(:to_s)}"}
        end
      rescue => exception
        return {error: exception.to_s}
      end
    end

    def calculate_tags(user) #tags cannot be temporary as they cannot be deleted
      tags = Array.new

      tags << "user.new"
      tags << "user.test" if user.interakt_test
      
      at_least_one_order_last_2_years = user.orders.paid.where("created_at > ?", 2.years.ago).count > 0
      more_than_1_orders = user.orders.paid.count > 1
      more_than_3_orders = user.orders.paid.count > 3
      more_than_10_orders = user.orders.paid.count > 10
      more_than_100_usd_total_last_2_years = user.orders.paid.where("created_at > ?", 2.years.ago).sum(:amount_cents) > 10000
      registeredMoreThan7DaysAgo = user.created_at < 7.days.ago
      any_order_over_100_usd = user.orders.paid.where("amount_cents > ?", 10000).count > 0

      tags << "user.registeredMoreThan7DaysAgo" if registeredMoreThan7DaysAgo
      tags << "orders.atLeastOneOrderLast2Years" if at_least_one_order_last_2_years
      tags << "orders.moreThan_1_orders" if more_than_1_orders
      tags << "orders.moreThan_3_orders" if more_than_3_orders
      tags << "orders.moreThan_10_orders" if more_than_10_orders
      tags << "orders.moreThan100UsdTotalLast2Years" if more_than_100_usd_total_last_2_years
      tags << "user.highValueAnyOrderOver100Usd" if any_order_over_100_usd
      return tags
    end

    def calculate_traits(user) #traits can be temporary as they can be updated, but string only
      traits = Hash.new
      traits["email"] = user.email
      traits["name"] = user.name
      traits["total_orders"] = user.orders.paid.count.to_s
      traits["total_amount_orders_USD"] = user.orders.paid.sum(:amount_cents) / 100
      traits["average_order_USD"] = user.orders.paid.average(:amount_cents) ?  (user.orders.paid.average(:amount_cents) / 100) : 0
      traits["last_order_year"] = user.orders.paid.last.try(:created_at).try(:year).try(:to_s)
      return traits
    end

    def create_event(hash) #hash with keys: user_id, event, traits hash
      begin
        user = User.find(hash[:user_id])
        options = {
          fullPhoneNumber: user.normalized_phone,
          event: hash[:event],
          traits: hash[:traits]
        }
        call_options = {
          headers: @headers,
          body: options.to_json,
        }
        response = self.class.post("/track/events/", call_options)
        if response.code == 200 || response.code == 202
          return response.parsed_response
        else
          return {error: "Code: #{response.code.to_s} - #{response.try(:to_s)}"}
        end
      rescue => exception
        return {error: exception.to_s}
      end
    end

    def send_message(hash) #hash with keys: user_id, template, language_code, header_values, body_values, button_values (header and body values are an array of strings, button values are a hash in format: {"0": ["1234"]})
      begin
        user = User.find(hash[:user_id])
        options = {
          fullPhoneNumber: user.normalized_phone,
          type: "Template",
          template: {
            name: hash[:template],
            languageCode: hash[:language_code],
            headerValues: hash[:header_values],
            bodyValues: hash[:body_values],
            buttonValues: hash[:button_values],
          }
        }
        call_options = {
          headers: @headers,
          body: options.to_json,
        }
        response = self.class.post("/message/", call_options)
        if response.code == 200 || response.code == 202
          return response.parsed_response
        else
          return {error: "Code: #{response.code.to_s} - #{response.try(:to_s)}"}
        end
      rescue => exception
        return {error: exception.to_s}
      end

    end

  end

