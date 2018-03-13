class CreateEinvoiceWorker
  include Sidekiq::Worker

  def perform(order)
    @order = Ecommerce::Order.find(order)
    @order.generate_einvoice
  end
end
