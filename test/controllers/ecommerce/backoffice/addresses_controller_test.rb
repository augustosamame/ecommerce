require 'test_helper'

module Ecommerce
  class Backoffice::AddressesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @backoffice_address = ecommerce_backoffice_addresses(:one)
    end

    test "should get index" do
      get backoffice_addresses_url
      assert_response :success
    end

    test "should get new" do
      get new_backoffice_address_url
      assert_response :success
    end

    test "should create backoffice_address" do
      assert_difference('Backoffice::Address.count') do
        post backoffice_addresses_url, params: { backoffice_address: { address_type: @backoffice_address.address_type, city: @backoffice_address.city, name: @backoffice_address.name, shipping_or_billing: @backoffice_address.shipping_or_billing, state: @backoffice_address.state, status: @backoffice_address.status, street2: @backoffice_address.street2, street: @backoffice_address.street, user_id: @backoffice_address.user_id } }
      end

      assert_redirected_to backoffice_address_url(Backoffice::Address.last)
    end

    test "should show backoffice_address" do
      get backoffice_address_url(@backoffice_address)
      assert_response :success
    end

    test "should get edit" do
      get edit_backoffice_address_url(@backoffice_address)
      assert_response :success
    end

    test "should update backoffice_address" do
      patch backoffice_address_url(@backoffice_address), params: { backoffice_address: { address_type: @backoffice_address.address_type, city: @backoffice_address.city, name: @backoffice_address.name, shipping_or_billing: @backoffice_address.shipping_or_billing, state: @backoffice_address.state, status: @backoffice_address.status, street2: @backoffice_address.street2, street: @backoffice_address.street, user_id: @backoffice_address.user_id } }
      assert_redirected_to backoffice_address_url(@backoffice_address)
    end

    test "should destroy backoffice_address" do
      assert_difference('Backoffice::Address.count', -1) do
        delete backoffice_address_url(@backoffice_address)
      end

      assert_redirected_to backoffice_addresses_url
    end
  end
end
