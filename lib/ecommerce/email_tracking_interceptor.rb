require "base64"
require "nokogiri"

module Ecommerce
  # ActionMailer delivery interceptor: reads the X-Email-Send-Token header
  # placed by `track_email`, rewrites all `<a href>` URLs in the HTML body
  # to redirect via /r/:token (so clicks can be attributed), and inserts a
  # 1x1 open-tracking pixel.
  class EmailTrackingInterceptor
    HEADER = Ecommerce::EmailTracking::HEADER
    SKIP_SCHEMES = %w[mailto: tel: javascript: data:].freeze
    UNSUB_REGEX  = /unsubscribe/i

    def self.delivering_email(mail)
      header = mail[HEADER]
      token  = header&.value
      return if token.blank?

      base = tracking_base_url
      part = html_part_for(mail)
      if part
        new_html = rewritten_html(part.body.decoded, token, base)
        part.body = new_html if new_html
      end

      # Strip our internal header so it never goes out to the recipient.
      mail[HEADER] = nil
    rescue => e
      Rails.logger.warn("[EmailTracking] interceptor error: #{e.class}: #{e.message}")
    end

    def self.tracking_base_url
      configured = Ecommerce.respond_to?(:tracking_base_url) ? Ecommerce.tracking_base_url : nil
      host = configured.presence ||
             ActionMailer::Base.default_url_options[:host] ||
             "expatshop.pe"
      return host if host.start_with?("http://", "https://")
      scheme = (Rails.env.development? && host.include?("localhost")) ? "http" : "https"
      port   = ActionMailer::Base.default_url_options[:port]
      port_str = port && !%w[80 443].include?(port.to_s) ? ":#{port}" : ""
      "#{scheme}://#{host}#{port_str}"
    end

    def self.html_part_for(mail)
      return mail.html_part if mail.multipart? && mail.html_part
      return mail if mail.content_type.to_s.include?("text/html")
      nil
    end

    def self.rewritten_html(html, token, base)
      return nil if html.to_s.strip.empty?
      doc = Nokogiri::HTML::DocumentFragment.parse(html)

      doc.css("a[href]").each do |a|
        href = a["href"].to_s.strip
        next if href.empty?
        next if SKIP_SCHEMES.any? { |s| href.start_with?(s) }
        next if a["data-no-track"] == "true"
        next if href =~ UNSUB_REGEX  # leave unsubscribe footers alone

        encoded = Base64.urlsafe_encode64(href, padding: false)
        a["href"] = "#{base}/r/#{token}?u=#{encoded}"
      end

      pixel = Nokogiri::HTML::DocumentFragment.parse(
        %Q(<img src="#{base}/r/#{token}/open.gif" width="1" height="1" alt="" style="border:0;width:1px;height:1px;display:block" />)
      )
      doc.add_child(pixel)
      doc.to_html
    end
  end
end
