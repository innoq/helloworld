require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "dashboard requires login" do
    get :dashboard
    assert_redirected_to :controller => 'auth', :action => 'login'
  end
end
