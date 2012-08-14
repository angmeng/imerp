require 'test_helper'

class ProductBrandsControllerTest < ActionController::TestCase
  setup do
    @product_brand = product_brands(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_brands)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_brand" do
    assert_difference('ProductBrand.count') do
      post :create, :product_brand => @product_brand.attributes
    end

    assert_redirected_to product_brand_path(assigns(:product_brand))
  end

  test "should show product_brand" do
    get :show, :id => @product_brand.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @product_brand.to_param
    assert_response :success
  end

  test "should update product_brand" do
    put :update, :id => @product_brand.to_param, :product_brand => @product_brand.attributes
    assert_redirected_to product_brand_path(assigns(:product_brand))
  end

  test "should destroy product_brand" do
    assert_difference('ProductBrand.count', -1) do
      delete :destroy, :id => @product_brand.to_param
    end

    assert_redirected_to product_brands_path
  end
end
