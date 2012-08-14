require 'test_helper'

class PackingListsControllerTest < ActionController::TestCase
  setup do
    @packing_list = packing_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:packing_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create packing_list" do
    assert_difference('PackingList.count') do
      post :create, :packing_list => @packing_list.attributes
    end

    assert_redirected_to packing_list_path(assigns(:packing_list))
  end

  test "should show packing_list" do
    get :show, :id => @packing_list.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @packing_list.to_param
    assert_response :success
  end

  test "should update packing_list" do
    put :update, :id => @packing_list.to_param, :packing_list => @packing_list.attributes
    assert_redirected_to packing_list_path(assigns(:packing_list))
  end

  test "should destroy packing_list" do
    assert_difference('PackingList.count', -1) do
      delete :destroy, :id => @packing_list.to_param
    end

    assert_redirected_to packing_lists_path
  end
end
