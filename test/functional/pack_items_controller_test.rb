require 'test_helper'

class PackItemsControllerTest < ActionController::TestCase
  setup do
    @pack_item = pack_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pack_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pack_item" do
    assert_difference('PackItem.count') do
      post :create, :pack_item => @pack_item.attributes
    end

    assert_redirected_to pack_item_path(assigns(:pack_item))
  end

  test "should show pack_item" do
    get :show, :id => @pack_item.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @pack_item.to_param
    assert_response :success
  end

  test "should update pack_item" do
    put :update, :id => @pack_item.to_param, :pack_item => @pack_item.attributes
    assert_redirected_to pack_item_path(assigns(:pack_item))
  end

  test "should destroy pack_item" do
    assert_difference('PackItem.count', -1) do
      delete :destroy, :id => @pack_item.to_param
    end

    assert_redirected_to pack_items_path
  end
end
