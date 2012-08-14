require 'test_helper'

class SupplierCreditNotesControllerTest < ActionController::TestCase
  setup do
    @supplier_credit_note = supplier_credit_notes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:supplier_credit_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create supplier_credit_note" do
    assert_difference('SupplierCreditNote.count') do
      post :create, :supplier_credit_note => @supplier_credit_note.attributes
    end

    assert_redirected_to supplier_credit_note_path(assigns(:supplier_credit_note))
  end

  test "should show supplier_credit_note" do
    get :show, :id => @supplier_credit_note.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @supplier_credit_note.to_param
    assert_response :success
  end

  test "should update supplier_credit_note" do
    put :update, :id => @supplier_credit_note.to_param, :supplier_credit_note => @supplier_credit_note.attributes
    assert_redirected_to supplier_credit_note_path(assigns(:supplier_credit_note))
  end

  test "should destroy supplier_credit_note" do
    assert_difference('SupplierCreditNote.count', -1) do
      delete :destroy, :id => @supplier_credit_note.to_param
    end

    assert_redirected_to supplier_credit_notes_path
  end
end
