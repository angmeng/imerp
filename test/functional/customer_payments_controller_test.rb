require 'test_helper'

class CustomerPaymentsControllerTest < ActionController::TestCase
  setup do
    @customer_payment = customer_payments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customer_payments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer_payment" do
    assert_difference('CustomerPayment.count') do
      post :create, :customer_payment => @customer_payment.attributes
    end

    assert_redirected_to customer_payment_path(assigns(:customer_payment))
  end

  test "should show customer_payment" do
    get :show, :id => @customer_payment.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @customer_payment.to_param
    assert_response :success
  end

  test "should update customer_payment" do
    put :update, :id => @customer_payment.to_param, :customer_payment => @customer_payment.attributes
    assert_redirected_to customer_payment_path(assigns(:customer_payment))
  end

  test "should destroy customer_payment" do
    assert_difference('CustomerPayment.count', -1) do
      delete :destroy, :id => @customer_payment.to_param
    end

    assert_redirected_to customer_payments_path
  end
end
