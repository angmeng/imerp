require 'test_helper'

class CreateInvoiceItemsControllerTest < ActionController::TestCase
  setup do
    @create_invoice_item = create_invoice_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:create_invoice_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create create_invoice_item" do
    assert_difference('CreateInvoiceItem.count') do
      post :create, :create_invoice_item => @create_invoice_item.attributes
    end

    assert_redirected_to create_invoice_item_path(assigns(:create_invoice_item))
  end

  test "should show create_invoice_item" do
    get :show, :id => @create_invoice_item.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @create_invoice_item.to_param
    assert_response :success
  end

  test "should update create_invoice_item" do
    put :update, :id => @create_invoice_item.to_param, :create_invoice_item => @create_invoice_item.attributes
    assert_redirected_to create_invoice_item_path(assigns(:create_invoice_item))
  end

  test "should destroy create_invoice_item" do
    assert_difference('CreateInvoiceItem.count', -1) do
      delete :destroy, :id => @create_invoice_item.to_param
    end

    assert_redirected_to create_invoice_items_path
  end
end
