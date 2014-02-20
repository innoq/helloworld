class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_login

  helper_method :current_user, :foreign_uri

  protected

  def check_login
    if params[:login_token]
      uri = foreign_uri('http://helloworld.innoq.com/check_login_token', :login_token => params[:login_token])
      if uri
        uri = URI.parse(uri)
        Net::HTTP.start(uri.host, uri.port) do |http|
          req = Net::HTTP::Get.new(uri.request_uri)
          req['Accept'] = "application/json"
          res = http.request(req)
          user = JSON.parse(res.body)
          session[:user] = user["id"]
          unless User.where(:id => user["id"]).last
            User.create!(:id => user["id"])
          end
        end
      elsif Rails.env.development?
        session[:user] = User.first.id
        flash[:info] = "Check Login disabled. Using random user for development purposes."
      else
        render :text => "Login currently disabled"
      end
    end

    redirect_to(foreign_uri('http://helloworld.innoq.com/login', :return_to => request.url) || Rails.configuration.helloworld[:base_uri]) unless current_user
  end

  def current_user
    @current_user ||= session[:user].nil? ? nil : User.includes(:profile => {:relations => :destination}).where(:id => session[:user]).last
  end

  def foreign_uri(resource, params = {})
    @foreign_links ||= ForeignLinks.new(Rails.configuration.helloworld[:base_uri],
      "contacts" => {
        "href" => contacts_url
      },
      "dashboard" => {
        "href" => dashboard_url
      },
      "private_profile" => {
        "href-template" => CGI.unescape(private_profile_url(:id => "{user_id}")),
        "href-vars" => {"user_id" => "http://helloworld.innoq.com/user_id"
        }
      }
    )
    @foreign_links.uri(resource, params)
  end

end
