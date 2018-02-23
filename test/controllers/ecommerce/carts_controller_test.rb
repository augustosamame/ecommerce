require 'test_helper'

module Ecommerce
  class CartsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @cart = ecommerce_carts(:one)
    end

    test "should get index" do
      get carts_url
      assert_response :success
    end

    test "should get new" do
      get new_cart_url
      assert_response :success
    end

    test "should create cart" do
      assert_difference('Cart.count') do
        post carts_url, params: { cart: { references: @cart.references, status: @cart.status } }
      end

      assert_redirected_to cart_url(Cart.last)
    end

    test "should show cart" do
      get cart_url(@cart)
      assert_response :success
    end

    test "should get edit" do
      get edit_cart_url(@cart)
      assert_response :success
    end

    test "should update cart" do
      patch cart_url(@cart), params: { cart: { references: @cart.references, status: @cart.status } }
      assert_redirected_to cart_url(@cart)
    end

    test "should destroy cart" do
      assert_difference('Cart.count', -1) do
        delete cart_url(@cart)
      end

      assert_redirected_to carts_url
    end
  end
end
