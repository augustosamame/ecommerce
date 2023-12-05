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

      #we must consolidate the traits to avoid duplicates due to guest checkouts
      user_total_orders = 0
      total_amount_orders_USD = 0
      average_order_USD = 0
      last_order_year = nil

      consolidated_users = User.where("LEFT(username, 9) = ?", user.username[0..8])
      
      consolidated_users.each do |consolidated_user|
        user_total_orders += consolidated_user.orders.paid.count
        total_amount_orders_USD += consolidated_user.orders.paid.sum(:amount_cents) / 100
        average_order_USD += consolidated_user.orders.paid.average(:amount_cents) ? (consolidated_user.orders.paid.average(:amount_cents) / 100) : 0
        last_order_year = consolidated_user.orders.paid.last.try(:created_at).try(:year).try(:to_s) if consolidated_user.orders.paid.last.try(:created_at).try(:year).try(:to_s) > last_order_year.to_i
      end

      traits = Hash.new
      traits["email"] = user.email
      traits["name"] = user.name
      traits["total_orders"] = user_total_orders.to_s
      traits["total_amount_orders_USD"] = total_amount_orders_USD.to_s
      traits["average_order_USD"] = average_order_USD.to_s
      traits["last_order_year"] = last_order_year.try(:to_s)
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

