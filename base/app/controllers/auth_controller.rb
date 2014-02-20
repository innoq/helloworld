# Note: this implementation is a security nightmare
# and NOT intended for production use.
class AuthController < ApplicationController

  skip_before_filter :check_login, :only => [:login, :authenticate, :register, :register_user, :check]

  def login
    if current_user && params[:return_to]
      redirect_to_return_address(current_user)
    else
      @user = User.new
      sample_user = random_user
      @hint = "Try user '#{sample_user.login}' with password '#{sample_user.password}' to get started." if sample_user
    end
  end

  def check
    if !params[:login_token]
      render :text => "Missing parameter 'login_token'", :status => 422
    elsif !(user = User.where(:login_token => params[:login_token]).first)
      render :text => "Invalid login token", :status => 403
    elsif  user.login_token_date < 30.seconds.ago
      render :text => "Invalid login token #{user.login_token_date} #{ 30.seconds.ago}", :status => 403
    else
      render :json => {:id => user.id, :login => user.login}
    end
  end

  def authenticate
    @user = User.find_by_login(params[:user][:login])
    if @user and @user.password == params[:user][:password]
      session[:user] = @user.id
      redirect_to_return_address(@user)
    else
      flash[:error] = "Wrong username/password combination"
      redirect_to :action => :login
    end
  end

  def logout
    session.delete(:user)
    @current_user = nil
  end

  def register
    @user = User.new
  end

  def register_user
    @user = User.find_by_login(params[:user][:login])
    if @user.nil?
      @user = User.create(params[:user])
      session[:user] = @user.id
      redirect_to_return_address(@user)
    else
      flash[:error] = "Could not create user - user name already taken"
      render :register
    end
  end

  protected

  def random_user
    User.find(:first, :offset => rand(User.count))
  end

  def redirect_to_return_address(user)
    raise "Coudn't return to return address without a logged in user" unless current_user
    dest = params[:return_to] || foreign_uri('http://helloworld.innoq.com/dashboard') || root_url
    dest = URI.parse(dest)
    current_user.login_token = SecureRandom.urlsafe_base64
    current_user.login_token_date = DateTime.now
    current_user.save
    dest.query = "login_token=#{current_user.login_token}&#{dest.query}"
    redirect_to dest.to_s
  end

end
