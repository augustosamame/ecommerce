module Ecommerce
    
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

    def create_user(hash) #hash with key: userId
      begin
        user = User.find!(hash[:userId])
        tags = Array.new
        tags << "user.new"
        tags << "user.test" if user.interakt_test
        options = {
          userId: user.id,
          fullPhoneNumber: user.normalized_phone,
          traits: {
            name: user.name,
            email: user.email
          },
          tags: tags
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

    def update_user(options) #hash with (optional) keys: userId, fullPhoneNumber, traits hash, tags hash
      begin
        user = User.find!(options[:user_id])
        tags = Array.new
        tags << "user.registeredMoreThan7DaysAgo" if user.created_at < 7.days.ago
        options = {
          fullPhoneNumber: user.normalized_phone,
          traits: {
            name: user.name,
            email: user.email
          },
          tags: tags
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

    def create_event(options) #hash with keys: user_id, event, traits hash
      begin
        user = User.find!(options[:user_id])
        options = {
          userId: user.id,
          event: options[:event],
          traits: traits
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

    def send_whatsapp(options) #hash with keys: user_id, template, language_code, header_values, body_values
      begin
        user = User.find!(options[:user_id])
        options = {
          fullPhoneNumber: user.normalized_phone,
          type: "Template",
          template: {
            name: options[:template],
            languageCode: options[:language_code],
            headerValues: options[:header_values],
            bodyValues: options[:body_values]
          }
        }
        call_options = {
          headers: @headers,
          body: options.to_json,
        }
        response = self.class.post("/whatsapp/send/", call_options)
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

end
