require 'test_helper'

class MixedProductsControllerTest < ActionController::TestCase
  setup do
    @mixed_product = mixed_products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mixed_products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mixed_product" do
    assert_difference('MixedProduct.count') do
      post :create, :mixed_product => @mixed_product.attributes
    end

    assert_redirected_to mixed_product_path(assigns(:mixed_product))
  end

  test "should show mixed_product" do
    get :show, :id => @mixed_product.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @mixed_product.to_param
    assert_response :success
  end

  test "should update mixed_product" do
    put :update, :id => @mixed_product.to_param, :mixed_product => @mixed_product.attributes
    assert_redirected_to mixed_product_path(assigns(:mixed_product))
  end

  test "should destroy mixed_product" do
    assert_difference('MixedProduct.count', -1) do
      delete :destroy, :id => @mixed_product.to_param
    end

    assert_redirected_to mixed_products_path
  end
end
