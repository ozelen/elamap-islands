require 'test_helper'

class HypsometriesControllerTest < ActionController::TestCase
  setup do
    @hypsometry = hypsometries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hypsometries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hypsometry" do
    assert_difference('Hypsometry.count') do
      post :create, hypsometry: { color: @hypsometry.color, name: @hypsometry.name, position: @hypsometry.position }
    end

    assert_redirected_to hypsometry_path(assigns(:hypsometry))
  end

  test "should show hypsometry" do
    get :show, id: @hypsometry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hypsometry
    assert_response :success
  end

  test "should update hypsometry" do
    put :update, id: @hypsometry, hypsometry: { color: @hypsometry.color, name: @hypsometry.name, position: @hypsometry.position }
    assert_redirected_to hypsometry_path(assigns(:hypsometry))
  end

  test "should destroy hypsometry" do
    assert_difference('Hypsometry.count', -1) do
      delete :destroy, id: @hypsometry
    end

    assert_redirected_to hypsometries_path
  end
end
