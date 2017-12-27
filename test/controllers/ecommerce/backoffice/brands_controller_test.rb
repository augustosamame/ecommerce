require 'test_helper'

module Ecommerce
  class Backoffice::BrandsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @backoffice_brand = ecommerce_backoffice_brands(:one)
    end

    test "should get index" do
      get backoffice_brands_url
      assert_response :success
    end

    test "should get new" do
      get new_backoffice_brand_url
      assert_response :success
    end

    test "should create backoffice_brand" do
      assert_difference('Backoffice::Brand.count') do
        post backoffice_brands_url, params: { backoffice_brand: { string: @backoffice_brand.string } }
      end

      assert_redirected_to backoffice_brand_url(Backoffice::Brand.last)
    end

    test "should show backoffice_brand" do
      get backoffice_brand_url(@backoffice_brand)
      assert_response :success
    end

    test "should get edit" do
      get edit_backoffice_brand_url(@backoffice_brand)
      assert_response :success
    end

    test "should update backoffice_brand" do
      patch backoffice_brand_url(@backoffice_brand), params: { backoffice_brand: { string: @backoffice_brand.string } }
      assert_redirected_to backoffice_brand_url(@backoffice_brand)
    end

    test "should destroy backoffice_brand" do
      assert_difference('Backoffice::Brand.count', -1) do
        delete backoffice_brand_url(@backoffice_brand)
      end

      assert_redirected_to backoffice_brands_url
    end
  end
end
