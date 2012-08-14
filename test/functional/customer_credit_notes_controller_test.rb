require 'test_helper'

class CustomerCreditNotesControllerTest < ActionController::TestCase
  setup do
    @customer_credit_note = customer_credit_notes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customer_credit_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer_credit_note" do
    assert_difference('CustomerCreditNote.count') do
      post :create, :customer_credit_note => @customer_credit_note.attributes
    end

    assert_redirected_to customer_credit_note_path(assigns(:customer_credit_note))
  end

  test "should show customer_credit_note" do
    get :show, :id => @customer_credit_note.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @customer_credit_note.to_param
    assert_response :success
  end

  test "should update customer_credit_note" do
    put :update, :id => @customer_credit_note.to_param, :customer_credit_note => @customer_credit_note.attributes
    assert_redirected_to customer_credit_note_path(assigns(:customer_credit_note))
  end

  test "should destroy customer_credit_note" do
    assert_difference('CustomerCreditNote.count', -1) do
      delete :destroy, :id => @customer_credit_note.to_param
    end

    assert_redirected_to customer_credit_notes_path
  end
end
