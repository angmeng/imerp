require 'test_helper'

class ProductDepartmentsControllerTest < ActionController::TestCase
  setup do
    @product_department = product_departments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_departments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_department" do
    assert_difference('ProductDepartment.count') do
      post :create, :product_department => @product_department.attributes
    end

    assert_redirected_to product_department_path(assigns(:product_department))
  end

  test "should show product_department" do
    get :show, :id => @product_department.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @product_department.to_param
    assert_response :success
  end

  test "should update product_department" do
    put :update, :id => @product_department.to_param, :product_department => @product_department.attributes
    assert_redirected_to product_department_path(assigns(:product_department))
  end

  test "should destroy product_department" do
    assert_difference('ProductDepartment.count', -1) do
      delete :destroy, :id => @product_department.to_param
    end

    assert_redirected_to product_departments_path
  end
end
