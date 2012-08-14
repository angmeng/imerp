require 'test_helper'

class StockLocationsControllerTest < ActionController::TestCase
  setup do
    @stock_location = stock_locations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_location" do
    assert_difference('StockLocation.count') do
      post :create, :stock_location => @stock_location.attributes
    end

    assert_redirected_to stock_location_path(assigns(:stock_location))
  end

  test "should show stock_location" do
    get :show, :id => @stock_location.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @stock_location.to_param
    assert_response :success
  end

  test "should update stock_location" do
    put :update, :id => @stock_location.to_param, :stock_location => @stock_location.attributes
    assert_redirected_to stock_location_path(assigns(:stock_location))
  end

  test "should destroy stock_location" do
    assert_difference('StockLocation.count', -1) do
      delete :destroy, :id => @stock_location.to_param
    end

    assert_redirected_to stock_locations_path
  end
end
