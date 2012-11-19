require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get buttons" do
    get :buttons
    assert_response :success
  end

  test "should get forms" do
    get :forms
    assert_response :success
  end

  test "should get components" do
    get :components
    assert_response :success
  end

end
