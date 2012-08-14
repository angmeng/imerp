require 'test_helper'

class StockTransfersControllerTest < ActionController::TestCase
  setup do
    @stock_transfer = stock_transfers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_transfers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_transfer" do
    assert_difference('StockTransfer.count') do
      post :create, :stock_transfer => @stock_transfer.attributes
    end

    assert_redirected_to stock_transfer_path(assigns(:stock_transfer))
  end

  test "should show stock_transfer" do
    get :show, :id => @stock_transfer.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @stock_transfer.to_param
    assert_response :success
  end

  test "should update stock_transfer" do
    put :update, :id => @stock_transfer.to_param, :stock_transfer => @stock_transfer.attributes
    assert_redirected_to stock_transfer_path(assigns(:stock_transfer))
  end

  test "should destroy stock_transfer" do
    assert_difference('StockTransfer.count', -1) do
      delete :destroy, :id => @stock_transfer.to_param
    end

    assert_redirected_to stock_transfers_path
  end
end
