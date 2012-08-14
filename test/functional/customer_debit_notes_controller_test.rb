require 'test_helper'

class CustomerDebitNotesControllerTest < ActionController::TestCase
  setup do
    @customer_debit_note = customer_debit_notes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customer_debit_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer_debit_note" do
    assert_difference('CustomerDebitNote.count') do
      post :create, :customer_debit_note => @customer_debit_note.attributes
    end

    assert_redirected_to customer_debit_note_path(assigns(:customer_debit_note))
  end

  test "should show customer_debit_note" do
    get :show, :id => @customer_debit_note.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @customer_debit_note.to_param
    assert_response :success
  end

  test "should update customer_debit_note" do
    put :update, :id => @customer_debit_note.to_param, :customer_debit_note => @customer_debit_note.attributes
    assert_redirected_to customer_debit_note_path(assigns(:customer_debit_note))
  end

  test "should destroy customer_debit_note" do
    assert_difference('CustomerDebitNote.count', -1) do
      delete :destroy, :id => @customer_debit_note.to_param
    end

    assert_redirected_to customer_debit_notes_path
  end
end
