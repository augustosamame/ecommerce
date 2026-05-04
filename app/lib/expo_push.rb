class ExpoPush
  include HTTParty
  base_uri 'https://exp.host'

  HEADERS = {
    "Content-Type" => "application/json",
    "Accept" => "application/json",
    "Accept-encoding" => "gzip, deflate"
  }

  # hash keys: user_id (or expo_push_token), title, body, data (optional)
  def send_notification(hash)
    token = hash[:expo_push_token].presence
    if token.blank? && hash[:user_id]
      user = User.find_by(id: hash[:user_id])
      token = user&.expo_push_token
    end
    return { error: "No expo_push_token" } if token.blank?

    message = build_message(token: token, title: hash[:title], body: hash[:body], data: hash[:data] || {})
    post_messages([message])
  end

  # Send to many tokens at once. Expo accepts up to 100 messages per request.
  # messages: array of hashes with keys: token, title, body, data
  def send_bulk(messages)
    return { error: "No messages" } if messages.blank?
    payload = messages.reject { |m| m[:token].blank? }.map do |m|
      build_message(token: m[:token], title: m[:title], body: m[:body], data: m[:data] || {})
    end
    return { error: "No valid tokens" } if payload.empty?
    payload.each_slice(100).map { |chunk| post_messages(chunk) }
  end

  private

  def build_message(token:, title:, body:, data:)
    {
      to: token,
      title: title,
      body: body,
      data: data,
      sound: "default",
      priority: "high",
      channelId: "default"
    }
  end

  def post_messages(messages)
    begin
      response = self.class.post("/--/api/v2/push/send", headers: HEADERS, body: messages.to_json)
      if response.code == 200
        parsed = response.parsed_response
        cleanup_invalid_tokens(messages, parsed)
        return parsed
      else
        return { error: "Code: #{response.code} - #{response.try(:to_s)}" }
      end
    rescue => exception
      return { error: exception.to_s }
    end
  end

  # Expo returns DeviceNotRegistered for tokens that have been invalidated
  # (app uninstalled, token rotated). Clear them from the user record.
  def cleanup_invalid_tokens(messages, parsed)
    return unless parsed.is_a?(Hash) && parsed["data"].is_a?(Array)
    parsed["data"].each_with_index do |result, idx|
      next unless result.is_a?(Hash) && result["status"] == "error"
      next unless result.dig("details", "error") == "DeviceNotRegistered"
      invalid_token = messages[idx][:to]
      User.where(expo_push_token: invalid_token).update_all(expo_push_token: nil) if invalid_token.present?
    end
  end
end
