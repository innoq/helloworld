class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_login
  before_filter :turn_esi_on

  helper_method :current_user

  protected

  def check_login
    redirect_to :controller => 'auth', :action => 'login' unless current_user
  end

  def turn_esi_on
    response['X-ESI'] = 'true'
  end

  def current_user
    @current_user ||= session[:user].nil? ? nil : User.includes(:profile => {:relations => :destination}).where(:id => session[:user]).last
  end

end
