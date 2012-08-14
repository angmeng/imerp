require 'test_helper'

class ProductLocationsControllerTest < ActionController::TestCase
  setup do
    @product_location = product_locations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_location" do
    assert_difference('ProductLocation.count') do
      post :create, :product_location => @product_location.attributes
    end

    assert_redirected_to product_location_path(assigns(:product_location))
  end

  test "should show product_location" do
    get :show, :id => @product_location.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @product_location.to_param
    assert_response :success
  end

  test "should update product_location" do
    put :update, :id => @product_location.to_param, :product_location => @product_location.attributes
    assert_redirected_to product_location_path(assigns(:product_location))
  end

  test "should destroy product_location" do
    assert_difference('ProductLocation.count', -1) do
      delete :destroy, :id => @product_location.to_param
    end

    assert_redirected_to product_locations_path
  end
end
