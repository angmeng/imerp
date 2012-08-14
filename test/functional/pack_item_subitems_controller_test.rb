require 'test_helper'

class PackItemSubitemsControllerTest < ActionController::TestCase
  setup do
    @pack_item_subitem = pack_item_subitems(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pack_item_subitems)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pack_item_subitem" do
    assert_difference('PackItemSubitem.count') do
      post :create, :pack_item_subitem => @pack_item_subitem.attributes
    end

    assert_redirected_to pack_item_subitem_path(assigns(:pack_item_subitem))
  end

  test "should show pack_item_subitem" do
    get :show, :id => @pack_item_subitem.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @pack_item_subitem.to_param
    assert_response :success
  end

  test "should update pack_item_subitem" do
    put :update, :id => @pack_item_subitem.to_param, :pack_item_subitem => @pack_item_subitem.attributes
    assert_redirected_to pack_item_subitem_path(assigns(:pack_item_subitem))
  end

  test "should destroy pack_item_subitem" do
    assert_difference('PackItemSubitem.count', -1) do
      delete :destroy, :id => @pack_item_subitem.to_param
    end

    assert_redirected_to pack_item_subitems_path
  end
end
