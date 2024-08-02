require 'httparty'
require 'digest'

class FacebookApi
  include HTTParty
  base_uri (ENV["ROLLBAR_ENV"] == 'production' ? 'https://graph.facebook.com/v20.0/454341000908415' : 'https://graph.facebook.com/v20.0/454341000908415')

  def initialize
    @access_token = ENV["FB_API_ACCESS_TOKEN"]
  end

  def send_event(event_name, params_hash)
    begin

      hashed_email = Digest::SHA256.hexdigest(params_hash["email"]) if params_hash["email"]

      custom_data = {
        "value" => params_hash["value"],
        "currency" => params_hash["currency"],
        "search_string" => params_hash["search_string"],
        "content_type" => params_hash["content_type"],
        "content_ids" => params_hash["content_ids"],
      }.compact #remove nil keys

      data = [
        {
          "event_name" => event_name,
          "event_time" => Time.now.to_i,
          "user_data" => {
            "em" => hashed_email,
            "external_id" => params_hash["user_id"]
          },
          "custom_data" => custom_data,
          "action_source" => "website",
          "event_source_url" => params_hash["event_source_url"],
        }
      ]

      response = HTTParty.post(
        "https://graph.facebook.com/v20.0/454341000908415/events?access_token=#{@access_token}",
        body: {
          data: data.to_json,
        }
      )

      # Debug the payload before sending
      puts "Payload: #{data.to_json}"

      if response.code == 200 || response.code == 202
        return response.parsed_response
      else
        return {error: "Code: #{response.code} - #{response.body}"}
      end
    rescue => exception
      return {error: exception.to_s}
    end
  end
end