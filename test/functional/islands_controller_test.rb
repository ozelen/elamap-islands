require 'test_helper'

class IslandsControllerTest < ActionController::TestCase
  setup do
    @island = islands(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:islands)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create island" do
    assert_difference('Island.count') do
      post :create, island: { begin: @island.begin, genre: @island.genre, grade: @island.grade, name: @island.name, size: @island.size }
    end

    assert_redirected_to island_path(assigns(:island))
  end

  test "should show island" do
    get :show, id: @island
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @island
    assert_response :success
  end

  test "should update island" do
    put :update, id: @island, island: { begin: @island.begin, genre: @island.genre, grade: @island.grade, name: @island.name, size: @island.size }
    assert_redirected_to island_path(assigns(:island))
  end

  test "should destroy island" do
    assert_difference('Island.count', -1) do
      delete :destroy, id: @island
    end

    assert_redirected_to islands_path
  end
end
