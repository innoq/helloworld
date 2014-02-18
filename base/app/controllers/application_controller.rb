class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_login

  helper_method :current_user, :foreign_uri

  protected

  def check_login
    redirect_to :controller => 'auth', :action => 'login' unless current_user
  end

  def current_user
    @current_user ||= session[:user].nil? ? nil : User.includes(:profile => :contacts).where(:id => session[:user]).last
  end

  def resources
    (@@external_resources || {}).merge(
      "http://helloworld.innoq.com/login" => {
        "href-template" => CGI.unescape(auth_login_url("return_to" => "{return_to}")),
        "href-vars" => {"return_to" => "http://helloworld.innoq.com/return_to"}
      },
      "http://helloworld.innoq.com/logout" => {
        "href" => auth_logout_url
      }
    )
  end

  def add_resources(resources)
    @@external_resources||= {}
    @@external_resources.merge!(resources)
    true
  end

  def foreign_uri(resource, params = {})
    ForeignLinks.uri(self.resources, resource, params)
  end

end
