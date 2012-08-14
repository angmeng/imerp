require 'test_helper'

class SupplierDebitNotesControllerTest < ActionController::TestCase
  setup do
    @supplier_debit_note = supplier_debit_notes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:supplier_debit_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create supplier_debit_note" do
    assert_difference('SupplierDebitNote.count') do
      post :create, :supplier_debit_note => @supplier_debit_note.attributes
    end

    assert_redirected_to supplier_debit_note_path(assigns(:supplier_debit_note))
  end

  test "should show supplier_debit_note" do
    get :show, :id => @supplier_debit_note.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @supplier_debit_note.to_param
    assert_response :success
  end

  test "should update supplier_debit_note" do
    put :update, :id => @supplier_debit_note.to_param, :supplier_debit_note => @supplier_debit_note.attributes
    assert_redirected_to supplier_debit_note_path(assigns(:supplier_debit_note))
  end

  test "should destroy supplier_debit_note" do
    assert_difference('SupplierDebitNote.count', -1) do
      delete :destroy, :id => @supplier_debit_note.to_param
    end

    assert_redirected_to supplier_debit_notes_path
  end
end
