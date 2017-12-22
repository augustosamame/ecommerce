require 'test_helper'

module Ecommerce
  class Backoffice::CategoriesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @backoffice_category = ecommerce_backoffice_categories(:one)
    end

    test "should get index" do
      get backoffice_categories_url
      assert_response :success
    end

    test "should get new" do
      get new_backoffice_category_url
      assert_response :success
    end

    test "should create backoffice_category" do
      assert_difference('Backoffice::Category.count') do
        post backoffice_categories_url, params: { backoffice_category: { image: @backoffice_category.image, name: @backoffice_category.name, status: @backoffice_category.status } }
      end

      assert_redirected_to backoffice_category_url(Backoffice::Category.last)
    end

    test "should show backoffice_category" do
      get backoffice_category_url(@backoffice_category)
      assert_response :success
    end

    test "should get edit" do
      get edit_backoffice_category_url(@backoffice_category)
      assert_response :success
    end

    test "should update backoffice_category" do
      patch backoffice_category_url(@backoffice_category), params: { backoffice_category: { image: @backoffice_category.image, name: @backoffice_category.name, status: @backoffice_category.status } }
      assert_redirected_to backoffice_category_url(@backoffice_category)
    end

    test "should destroy backoffice_category" do
      assert_difference('Backoffice::Category.count', -1) do
        delete backoffice_category_url(@backoffice_category)
      end

      assert_redirected_to backoffice_categories_url
    end
  end
end
