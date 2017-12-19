require 'test_helper'

module Ecommerce
  class Backoffice::ProductVariantsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @backoffice_product_variant = ecommerce_backoffice_product_variants(:one)
    end

    test "should get index" do
      get backoffice_product_variants_url
      assert_response :success
    end

    test "should get new" do
      get new_backoffice_product_variant_url
      assert_response :success
    end

    test "should create backoffice_product_variant" do
      assert_difference('Backoffice::ProductVariant.count') do
        post backoffice_product_variants_url, params: { backoffice_product_variant: { product_id: @backoffice_product_variant.product_id, variant_name: @backoffice_product_variant.variant_name } }
      end

      assert_redirected_to backoffice_product_variant_url(Backoffice::ProductVariant.last)
    end

    test "should show backoffice_product_variant" do
      get backoffice_product_variant_url(@backoffice_product_variant)
      assert_response :success
    end

    test "should get edit" do
      get edit_backoffice_product_variant_url(@backoffice_product_variant)
      assert_response :success
    end

    test "should update backoffice_product_variant" do
      patch backoffice_product_variant_url(@backoffice_product_variant), params: { backoffice_product_variant: { product_id: @backoffice_product_variant.product_id, variant_name: @backoffice_product_variant.variant_name } }
      assert_redirected_to backoffice_product_variant_url(@backoffice_product_variant)
    end

    test "should destroy backoffice_product_variant" do
      assert_difference('Backoffice::ProductVariant.count', -1) do
        delete backoffice_product_variant_url(@backoffice_product_variant)
      end

      assert_redirected_to backoffice_product_variants_url
    end
  end
end
