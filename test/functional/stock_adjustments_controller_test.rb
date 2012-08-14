require 'test_helper'

class StockAdjustmentsControllerTest < ActionController::TestCase
  setup do
    @stock_adjustment = stock_adjustments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_adjustments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_adjustment" do
    assert_difference('StockAdjustment.count') do
      post :create, :stock_adjustment => @stock_adjustment.attributes
    end

    assert_redirected_to stock_adjustment_path(assigns(:stock_adjustment))
  end

  test "should show stock_adjustment" do
    get :show, :id => @stock_adjustment.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @stock_adjustment.to_param
    assert_response :success
  end

  test "should update stock_adjustment" do
    put :update, :id => @stock_adjustment.to_param, :stock_adjustment => @stock_adjustment.attributes
    assert_redirected_to stock_adjustment_path(assigns(:stock_adjustment))
  end

  test "should destroy stock_adjustment" do
    assert_difference('StockAdjustment.count', -1) do
      delete :destroy, :id => @stock_adjustment.to_param
    end

    assert_redirected_to stock_adjustments_path
  end
end
