class AddInvoicingRefsToProofOfDeliveryImages < ActiveRecord::Migration[7.0]
  # Delivery-confirmation photos for MANUAL comprobantes/guias issued through
  # the invoicing platform live in the SAME table as website-order PODs; a
  # row belongs to exactly one of order / invoicing invoice / invoicing guia.
  def change
    change_column_null :ecommerce_proof_of_delivery_images, :order_id, true
    add_column :ecommerce_proof_of_delivery_images, :invoicing_invoice_id, :bigint
    add_column :ecommerce_proof_of_delivery_images, :invoicing_guia_id, :bigint
    add_index :ecommerce_proof_of_delivery_images, :invoicing_invoice_id, name: "index_pod_images_on_invoicing_invoice_id"
    add_index :ecommerce_proof_of_delivery_images, :invoicing_guia_id, name: "index_pod_images_on_invoicing_guia_id"
  end
end
