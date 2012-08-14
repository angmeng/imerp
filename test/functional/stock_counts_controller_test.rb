require 'test_helper'

class StockCountsControllerTest < ActionController::TestCase
  setup do
    @stock_count = stock_counts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_counts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_count" do
    assert_difference('StockCount.count') do
      post :create, :stock_count => @stock_count.attributes
    end

    assert_redirected_to stock_count_path(assigns(:stock_count))
  end

  test "should show stock_count" do
    get :show, :id => @stock_count.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @stock_count.to_param
    assert_response :success
  end

  test "should update stock_count" do
    put :update, :id => @stock_count.to_param, :stock_count => @stock_count.attributes
    assert_redirected_to stock_count_path(assigns(:stock_count))
  end

  test "should destroy stock_count" do
    assert_difference('StockCount.count', -1) do
      delete :destroy, :id => @stock_count.to_param
    end

    assert_redirected_to stock_counts_path
  end
end
