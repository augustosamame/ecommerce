require 'test_helper'

module Ecommerce
  class Backoffice::OrdersControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @backoffice_order = ecommerce_backoffice_orders(:one)
    end

    test "should get index" do
      get backoffice_orders_url
      assert_response :success
    end

    test "should get new" do
      get new_backoffice_order_url
      assert_response :success
    end

    test "should create backoffice_order" do
      assert_difference('Backoffice::Order.count') do
        post backoffice_orders_url, params: { backoffice_order: { amount_cents: @backoffice_order.amount_cents, billing_address_id: @backoffice_order.billing_address_id, coupon_id: @backoffice_order.coupon_id, payment_status: @backoffice_order.payment_status, shipping_address_id: @backoffice_order.shipping_address_id, stage: @backoffice_order.stage, status: @backoffice_order.status, user_id: @backoffice_order.user_id } }
      end

      assert_redirected_to backoffice_order_url(Backoffice::Order.last)
    end

    test "should show backoffice_order" do
      get backoffice_order_url(@backoffice_order)
      assert_response :success
    end

    test "should get edit" do
      get edit_backoffice_order_url(@backoffice_order)
      assert_response :success
    end

    test "should update backoffice_order" do
      patch backoffice_order_url(@backoffice_order), params: { backoffice_order: { amount_cents: @backoffice_order.amount_cents, billing_address_id: @backoffice_order.billing_address_id, coupon_id: @backoffice_order.coupon_id, payment_status: @backoffice_order.payment_status, shipping_address_id: @backoffice_order.shipping_address_id, stage: @backoffice_order.stage, status: @backoffice_order.status, user_id: @backoffice_order.user_id } }
      assert_redirected_to backoffice_order_url(@backoffice_order)
    end

    test "should destroy backoffice_order" do
      assert_difference('Backoffice::Order.count', -1) do
        delete backoffice_order_url(@backoffice_order)
      end

      assert_redirected_to backoffice_orders_url
    end
  end
end
