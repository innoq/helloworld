class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_login

  helper_method :current_user

  protected

  def check_login
    redirect_to :controller => 'auth', :action => 'login' unless current_user
  end

  def setup_context
    @profile = current_user.profile || current_user.create_profile
    @contact_count = @profile.contact_count
    @message_count = @profile.message_count
  end

  def current_user
    @current_user ||= session[:user].nil? ? nil : User.find(session[:user])
  end

end
