class AddCountryAndTipoProductoToProducts < ActiveRecord::Migration[7.0]
  # Legacy-report fields (Rentabilidad: PAIS, TIPO_PRODUCTO). The SISCONT
  # cuenta/linea pair needs no column — AccountingCodeFamily already models it.
  def change
    add_column :ecommerce_products, :country, :string
    add_column :ecommerce_products, :tipo_producto, :string
  end
end
