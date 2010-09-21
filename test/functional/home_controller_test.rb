require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "private pages require login" do
    get :dashboard
    assert_redirected_to :controller => 'auth_controller', :action => 'login'
  end
end
