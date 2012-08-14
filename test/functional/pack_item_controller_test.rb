require 'test_helper'

class PackItemControllerTest < ActionController::TestCase
  test "should get pack_id:integer" do
    get :pack_id:integer
    assert_response :success
  end

  test "should get product_id:integer" do
    get :product_id:integer
    assert_response :success
  end

  test "should get product_uom_id:integer" do
    get :product_uom_id:integer
    assert_response :success
  end

  test "should get stock_location_id:integer" do
    get :stock_location_id:integer
    assert_response :success
  end

  test "should get quantity:decimal" do
    get :quantity:decimal
    assert_response :success
  end

  test "should get cost:decimal" do
    get :cost:decimal
    assert_response :success
  end

end
