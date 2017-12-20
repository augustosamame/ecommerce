require 'test_helper'

module Ecommerce
  class ProductsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @backoffice_product = ecommerce_backoffice_products(:one)
    end

    test "should get index" do
      get backoffice_products_url
      assert_response :success
    end

    test "should get new" do
      get new_backoffice_product_url
      assert_response :success
    end

    test "should create backoffice_product" do
      assert_difference('Product.count') do
        post backoffice_products_url, params: { backoffice_product: { description: @backoffice_product.description, image: @backoffice_product.image, name: @backoffice_product.name } }
      end

      assert_redirected_to backoffice_product_url(Product.last)
    end

    test "should show backoffice_product" do
      get backoffice_product_url(@backoffice_product)
      assert_response :success
    end

    test "should get edit" do
      get edit_backoffice_product_url(@backoffice_product)
      assert_response :success
    end

    test "should update backoffice_product" do
      patch backoffice_product_url(@backoffice_product), params: { backoffice_product: { description: @backoffice_product.description, image: @backoffice_product.image, name: @backoffice_product.name } }
      assert_redirected_to backoffice_product_url(@backoffice_product)
    end

    test "should destroy backoffice_product" do
      assert_difference('Product.count', -1) do
        delete backoffice_product_url(@backoffice_product)
      end

      assert_redirected_to backoffice_products_url
    end
  end
end
