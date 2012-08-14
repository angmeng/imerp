require 'test_helper'

class PurchaseRequisitionsControllerTest < ActionController::TestCase
  setup do
    @purchase_requisition = purchase_requisitions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:purchase_requisitions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create purchase_requisition" do
    assert_difference('PurchaseRequisition.count') do
      post :create, :purchase_requisition => @purchase_requisition.attributes
    end

    assert_redirected_to purchase_requisition_path(assigns(:purchase_requisition))
  end

  test "should show purchase_requisition" do
    get :show, :id => @purchase_requisition.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @purchase_requisition.to_param
    assert_response :success
  end

  test "should update purchase_requisition" do
    put :update, :id => @purchase_requisition.to_param, :purchase_requisition => @purchase_requisition.attributes
    assert_redirected_to purchase_requisition_path(assigns(:purchase_requisition))
  end

  test "should destroy purchase_requisition" do
    assert_difference('PurchaseRequisition.count', -1) do
      delete :destroy, :id => @purchase_requisition.to_param
    end

    assert_redirected_to purchase_requisitions_path
  end
end
