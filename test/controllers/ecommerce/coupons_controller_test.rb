require 'test_helper'

module Ecommerce
  class CouponsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @coupon = ecommerce_coupons(:one)
    end

    test "should get index" do
      get coupons_url
      assert_response :success
    end

    test "should get new" do
      get new_coupon_url
      assert_response :success
    end

    test "should create coupon" do
      assert_difference('Coupon.count') do
        post coupons_url, params: { coupon: { coupon_code: @coupon.coupon_code, coupon_type: @coupon.coupon_type, dicount_percentage: @coupon.dicount_percentage, discount_fixed: @coupon.discount_fixed, discount_threshold: @coupon.discount_threshold, end_date: @coupon.end_date, free_shipping: @coupon.free_shipping, max_uses: @coupon.max_uses, max_uses_per_user: @coupon.max_uses_per_user, start_date: @coupon.start_date, status: @coupon.status } }
      end

      assert_redirected_to coupon_url(Coupon.last)
    end

    test "should show coupon" do
      get coupon_url(@coupon)
      assert_response :success
    end

    test "should get edit" do
      get edit_coupon_url(@coupon)
      assert_response :success
    end

    test "should update coupon" do
      patch coupon_url(@coupon), params: { coupon: { coupon_code: @coupon.coupon_code, coupon_type: @coupon.coupon_type, dicount_percentage: @coupon.dicount_percentage, discount_fixed: @coupon.discount_fixed, discount_threshold: @coupon.discount_threshold, end_date: @coupon.end_date, free_shipping: @coupon.free_shipping, max_uses: @coupon.max_uses, max_uses_per_user: @coupon.max_uses_per_user, start_date: @coupon.start_date, status: @coupon.status } }
      assert_redirected_to coupon_url(@coupon)
    end

    test "should destroy coupon" do
      assert_difference('Coupon.count', -1) do
        delete coupon_url(@coupon)
      end

      assert_redirected_to coupons_url
    end
  end
end
