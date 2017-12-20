require 'test_helper'

module Ecommerce
  class ProductVariantValuesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @backoffice_product_variant_value = ecommerce_backoffice_product_variant_values(:one)
    end

    test "should get index" do
      get backoffice_product_variant_values_url
      assert_response :success
    end

    test "should get new" do
      get new_backoffice_product_variant_value_url
      assert_response :success
    end

    test "should create backoffice_product_variant_value" do
      assert_difference('ProductVariantValue.count') do
        post backoffice_product_variant_values_url, params: { backoffice_product_variant_value: { product_id: @backoffice_product_variant_value.product_id, product_variant_id: @backoffice_product_variant_value.product_variant_id, status: @backoffice_product_variant_value.status, value: @backoffice_product_variant_value.value } }
      end

      assert_redirected_to backoffice_product_variant_value_url(ProductVariantValue.last)
    end

    test "should show backoffice_product_variant_value" do
      get backoffice_product_variant_value_url(@backoffice_product_variant_value)
      assert_response :success
    end

    test "should get edit" do
      get edit_backoffice_product_variant_value_url(@backoffice_product_variant_value)
      assert_response :success
    end

    test "should update backoffice_product_variant_value" do
      patch backoffice_product_variant_value_url(@backoffice_product_variant_value), params: { backoffice_product_variant_value: { product_id: @backoffice_product_variant_value.product_id, product_variant_id: @backoffice_product_variant_value.product_variant_id, status: @backoffice_product_variant_value.status, value: @backoffice_product_variant_value.value } }
      assert_redirected_to backoffice_product_variant_value_url(@backoffice_product_variant_value)
    end

    test "should destroy backoffice_product_variant_value" do
      assert_difference('ProductVariantValue.count', -1) do
        delete backoffice_product_variant_value_url(@backoffice_product_variant_value)
      end

      assert_redirected_to backoffice_product_variant_values_url
    end
  end
end
