require 'test_helper'

class ProductUomsControllerTest < ActionController::TestCase
  setup do
    @product_uom = product_uoms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_uoms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_uom" do
    assert_difference('ProductUom.count') do
      post :create, :product_uom => @product_uom.attributes
    end

    assert_redirected_to product_uom_path(assigns(:product_uom))
  end

  test "should show product_uom" do
    get :show, :id => @product_uom.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @product_uom.to_param
    assert_response :success
  end

  test "should update product_uom" do
    put :update, :id => @product_uom.to_param, :product_uom => @product_uom.attributes
    assert_redirected_to product_uom_path(assigns(:product_uom))
  end

  test "should destroy product_uom" do
    assert_difference('ProductUom.count', -1) do
      delete :destroy, :id => @product_uom.to_param
    end

    assert_redirected_to product_uoms_path
  end
end
