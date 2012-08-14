require 'test_helper'

class GoodsReceiveNotesControllerTest < ActionController::TestCase
  setup do
    @goods_receive_note = goods_receive_notes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:goods_receive_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create goods_receive_note" do
    assert_difference('GoodsReceiveNote.count') do
      post :create, :goods_receive_note => @goods_receive_note.attributes
    end

    assert_redirected_to goods_receive_note_path(assigns(:goods_receive_note))
  end

  test "should show goods_receive_note" do
    get :show, :id => @goods_receive_note.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @goods_receive_note.to_param
    assert_response :success
  end

  test "should update goods_receive_note" do
    put :update, :id => @goods_receive_note.to_param, :goods_receive_note => @goods_receive_note.attributes
    assert_redirected_to goods_receive_note_path(assigns(:goods_receive_note))
  end

  test "should destroy goods_receive_note" do
    assert_difference('GoodsReceiveNote.count', -1) do
      delete :destroy, :id => @goods_receive_note.to_param
    end

    assert_redirected_to goods_receive_notes_path
  end
end
