require 'test_helper'

class StockDisposalsControllerTest < ActionController::TestCase
  setup do
    @stock_disposal = stock_disposals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_disposals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_disposal" do
    assert_difference('StockDisposal.count') do
      post :create, :stock_disposal => @stock_disposal.attributes
    end

    assert_redirected_to stock_disposal_path(assigns(:stock_disposal))
  end

  test "should show stock_disposal" do
    get :show, :id => @stock_disposal.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @stock_disposal.to_param
    assert_response :success
  end

  test "should update stock_disposal" do
    put :update, :id => @stock_disposal.to_param, :stock_disposal => @stock_disposal.attributes
    assert_redirected_to stock_disposal_path(assigns(:stock_disposal))
  end

  test "should destroy stock_disposal" do
    assert_difference('StockDisposal.count', -1) do
      delete :destroy, :id => @stock_disposal.to_param
    end

    assert_redirected_to stock_disposals_path
  end
end
