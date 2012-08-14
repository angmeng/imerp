require 'test_helper'

class ProductRacksControllerTest < ActionController::TestCase
  setup do
    @product_rack = product_racks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_racks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_rack" do
    assert_difference('ProductRack.count') do
      post :create, :product_rack => @product_rack.attributes
    end

    assert_redirected_to product_rack_path(assigns(:product_rack))
  end

  test "should show product_rack" do
    get :show, :id => @product_rack.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @product_rack.to_param
    assert_response :success
  end

  test "should update product_rack" do
    put :update, :id => @product_rack.to_param, :product_rack => @product_rack.attributes
    assert_redirected_to product_rack_path(assigns(:product_rack))
  end

  test "should destroy product_rack" do
    assert_difference('ProductRack.count', -1) do
      delete :destroy, :id => @product_rack.to_param
    end

    assert_redirected_to product_racks_path
  end
end
