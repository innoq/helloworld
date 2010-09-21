class ApplicationController < ActionController::Base
  protect_from_forgery

  def setup_context
    @user = session[:user].nil? ? nil : User.find(session[:user])
    if @user.nil?
      redirect_to :controller => 'auth', :action => 'login'
    else
      @profile = @user.profile || @user.create_profile
      @contact_count = @profile.contact_count
      @message_count = @profile.message_count
    end
  end
  
end
