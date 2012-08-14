require 'test_helper'

class ProductKindsControllerTest < ActionController::TestCase
  setup do
    @product_kind = product_kinds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_kinds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_kind" do
    assert_difference('ProductKind.count') do
      post :create, :product_kind => @product_kind.attributes
    end

    assert_redirected_to product_kind_path(assigns(:product_kind))
  end

  test "should show product_kind" do
    get :show, :id => @product_kind.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @product_kind.to_param
    assert_response :success
  end

  test "should update product_kind" do
    put :update, :id => @product_kind.to_param, :product_kind => @product_kind.attributes
    assert_redirected_to product_kind_path(assigns(:product_kind))
  end

  test "should destroy product_kind" do
    assert_difference('ProductKind.count', -1) do
      delete :destroy, :id => @product_kind.to_param
    end

    assert_redirected_to product_kinds_path
  end
end
