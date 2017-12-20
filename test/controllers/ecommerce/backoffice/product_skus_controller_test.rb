require 'test_helper'

module Ecommerce
  class ProductSkusControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @backoffice_product_sku = ecommerce_backoffice_product_skus(:one)
    end

    test "should get index" do
      get backoffice_product_skus_url
      assert_response :success
    end

    test "should get new" do
      get new_backoffice_product_sku_url
      assert_response :success
    end

    test "should create backoffice_product_sku" do
      assert_difference('ProductSku.count') do
        post backoffice_product_skus_url, params: { backoffice_product_sku: { price_cents: @backoffice_product_sku.price_cents, product_id: @backoffice_product_sku.product_id, product_variant_id: @backoffice_product_sku.product_variant_id, sku: @backoffice_product_sku.sku, status: @backoffice_product_sku.status } }
      end

      assert_redirected_to backoffice_product_sku_url(ProductSku.last)
    end

    test "should show backoffice_product_sku" do
      get backoffice_product_sku_url(@backoffice_product_sku)
      assert_response :success
    end

    test "should get edit" do
      get edit_backoffice_product_sku_url(@backoffice_product_sku)
      assert_response :success
    end

    test "should update backoffice_product_sku" do
      patch backoffice_product_sku_url(@backoffice_product_sku), params: { backoffice_product_sku: { price_cents: @backoffice_product_sku.price_cents, product_id: @backoffice_product_sku.product_id, product_variant_id: @backoffice_product_sku.product_variant_id, sku: @backoffice_product_sku.sku, status: @backoffice_product_sku.status } }
      assert_redirected_to backoffice_product_sku_url(@backoffice_product_sku)
    end

    test "should destroy backoffice_product_sku" do
      assert_difference('ProductSku.count', -1) do
        delete backoffice_product_sku_url(@backoffice_product_sku)
      end

      assert_redirected_to backoffice_product_skus_url
    end
  end
end
