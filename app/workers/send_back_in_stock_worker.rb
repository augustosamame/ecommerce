class SendBackInStockWorker
  include Sidekiq::Worker

  def perform(product_name, product_id, user_id)
    Interakt.new.send_message({
      user_id: user_id,
      template: "back_in_stock_alert_v2",
      language_code: "es",
      header_values: [],
      body_values: [product_name],
      button_values: {"0": [product_id]}
    })
  end
end
