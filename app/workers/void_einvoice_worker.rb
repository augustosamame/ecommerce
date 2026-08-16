# Voids an order's comprobante in the NEW invoicing platform (→ Nubefact)
# when the order itself is voided. Deliberately posts ONLY to the new-flow
# gateway: the legacy production processor (Sinergia) flow is not touched —
# during the parallel run this keeps the sandbox mirror in sync, and after
# cutover it performs the real SUNAT anulación.
class VoidEinvoiceWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(order_id)
    order = Ecommerce::Order.find_by(id: order_id)
    return if order.nil? || order.efact_number.blank?

    url_value = ENV.fetch("NEW_INVOICING_URL") { Ecommerce::Control.find_by(name: "new_invoicing_url")&.text_value }
    token     = ENV.fetch("NEW_INVOICING_TOKEN") { Ecommerce::Control.find_by(name: "new_invoicing_token")&.text_value }
    if url_value.blank? || token.blank?
      Rails.logger.warn("[VoidEinvoiceWorker] order #{order.id}: gateway url/token not configured; skipped")
      return
    end

    url = URI(url_value)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == "https"
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{token}"
    request.body = {
      einvoice_type: "anulacion",
      affected_document: order.efact_number,
      void_reason: "Anulación de pedido ##{order.id}"
    }.to_json

    response = http.request(request)
    Rails.logger.info("[VoidEinvoiceWorker] order #{order.id} #{order.efact_number}: #{response.code} #{response.body.to_s[0, 200]}")
  end
end
