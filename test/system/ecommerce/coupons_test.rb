require "application_system_test_case"

module Ecommerce
  class CouponsTest < ApplicationSystemTestCase
    setup do
      @coupon = ecommerce_coupons(:one)
    end

    test "visiting the index" do
      visit coupons_url
      assert_selector "h1", text: "Coupons"
    end

    test "creating a Coupon" do
      visit coupons_url
      click_on "New Coupon"

      fill_in "Coupon Code", with: @coupon.coupon_code
      fill_in "Coupon Type", with: @coupon.coupon_type
      fill_in "Dicount Percentage", with: @coupon.dicount_percentage
      fill_in "Discount Fixed", with: @coupon.discount_fixed
      fill_in "Discount Threshold", with: @coupon.discount_threshold
      fill_in "End Date", with: @coupon.end_date
      fill_in "Free Shipping", with: @coupon.free_shipping
      fill_in "Max Uses", with: @coupon.max_uses
      fill_in "Max Uses Per User", with: @coupon.max_uses_per_user
      fill_in "Start Date", with: @coupon.start_date
      fill_in "Status", with: @coupon.status
      click_on "Create Coupon"

      assert_text "Coupon was successfully created"
      click_on "Back"
    end

    test "updating a Coupon" do
      visit coupons_url
      click_on "Edit", match: :first

      fill_in "Coupon Code", with: @coupon.coupon_code
      fill_in "Coupon Type", with: @coupon.coupon_type
      fill_in "Dicount Percentage", with: @coupon.dicount_percentage
      fill_in "Discount Fixed", with: @coupon.discount_fixed
      fill_in "Discount Threshold", with: @coupon.discount_threshold
      fill_in "End Date", with: @coupon.end_date
      fill_in "Free Shipping", with: @coupon.free_shipping
      fill_in "Max Uses", with: @coupon.max_uses
      fill_in "Max Uses Per User", with: @coupon.max_uses_per_user
      fill_in "Start Date", with: @coupon.start_date
      fill_in "Status", with: @coupon.status
      click_on "Update Coupon"

      assert_text "Coupon was successfully updated"
      click_on "Back"
    end

    test "destroying a Coupon" do
      visit coupons_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Coupon was successfully destroyed"
    end
  end
end
