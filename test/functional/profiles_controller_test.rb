require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  test "private pages require login" do
    [:myprofile].each do |route|
      get route
      assert_redirected_to :controller => 'auth', :action => 'login'
    end
  end
end
