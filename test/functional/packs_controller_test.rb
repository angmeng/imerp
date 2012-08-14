require 'test_helper'

class PacksControllerTest < ActionController::TestCase
  setup do
    @pack = packs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:packs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pack" do
    assert_difference('Pack.count') do
      post :create, :pack => @pack.attributes
    end

    assert_redirected_to pack_path(assigns(:pack))
  end

  test "should show pack" do
    get :show, :id => @pack.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @pack.to_param
    assert_response :success
  end

  test "should update pack" do
    put :update, :id => @pack.to_param, :pack => @pack.attributes
    assert_redirected_to pack_path(assigns(:pack))
  end

  test "should destroy pack" do
    assert_difference('Pack.count', -1) do
      delete :destroy, :id => @pack.to_param
    end

    assert_redirected_to packs_path
  end
end
