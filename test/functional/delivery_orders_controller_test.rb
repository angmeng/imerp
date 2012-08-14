require 'test_helper'

class DeliveryOrdersControllerTest < ActionController::TestCase
  setup do
    @delivery_order = delivery_orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:delivery_orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create delivery_order" do
    assert_difference('DeliveryOrder.count') do
      post :create, :delivery_order => @delivery_order.attributes
    end

    assert_redirected_to delivery_order_path(assigns(:delivery_order))
  end

  test "should show delivery_order" do
    get :show, :id => @delivery_order.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @delivery_order.to_param
    assert_response :success
  end

  test "should update delivery_order" do
    put :update, :id => @delivery_order.to_param, :delivery_order => @delivery_order.attributes
    assert_redirected_to delivery_order_path(assigns(:delivery_order))
  end

  test "should destroy delivery_order" do
    assert_difference('DeliveryOrder.count', -1) do
      delete :destroy, :id => @delivery_order.to_param
    end

    assert_redirected_to delivery_orders_path
  end
end
