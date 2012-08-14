require 'test_helper'

class PriceLevelsControllerTest < ActionController::TestCase
  setup do
    @price_level = price_levels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:price_levels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create price_level" do
    assert_difference('PriceLevel.count') do
      post :create, :price_level => @price_level.attributes
    end

    assert_redirected_to price_level_path(assigns(:price_level))
  end

  test "should show price_level" do
    get :show, :id => @price_level.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @price_level.to_param
    assert_response :success
  end

  test "should update price_level" do
    put :update, :id => @price_level.to_param, :price_level => @price_level.attributes
    assert_redirected_to price_level_path(assigns(:price_level))
  end

  test "should destroy price_level" do
    assert_difference('PriceLevel.count', -1) do
      delete :destroy, :id => @price_level.to_param
    end

    assert_redirected_to price_levels_path
  end
end
