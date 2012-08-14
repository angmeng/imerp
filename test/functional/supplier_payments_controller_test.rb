require 'test_helper'

class SupplierPaymentsControllerTest < ActionController::TestCase
  setup do
    @supplier_payment = supplier_payments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:supplier_payments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create supplier_payment" do
    assert_difference('SupplierPayment.count') do
      post :create, :supplier_payment => @supplier_payment.attributes
    end

    assert_redirected_to supplier_payment_path(assigns(:supplier_payment))
  end

  test "should show supplier_payment" do
    get :show, :id => @supplier_payment.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @supplier_payment.to_param
    assert_response :success
  end

  test "should update supplier_payment" do
    put :update, :id => @supplier_payment.to_param, :supplier_payment => @supplier_payment.attributes
    assert_redirected_to supplier_payment_path(assigns(:supplier_payment))
  end

  test "should destroy supplier_payment" do
    assert_difference('SupplierPayment.count', -1) do
      delete :destroy, :id => @supplier_payment.to_param
    end

    assert_redirected_to supplier_payments_path
  end
end
