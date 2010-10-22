class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_login

  helper_method :current_user

  protected

  def check_login
    redirect_to :controller => 'auth', :action => 'login' unless current_user
  end

  def current_user
    @current_user ||= session[:user].nil? ? nil : User.last(:conditions => {:id => session[:user]})
  end

end
