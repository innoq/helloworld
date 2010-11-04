# Note: this implementation is a security nightmare
# and NOT intended for production use.
class AuthController < ApplicationController

  skip_before_filter :check_login, :only => [:login, :authenticate, :register, :register_user]

  def login
    @user = User.new
    @dest ||= dashboard_path
    sample_user = random_user
    @hint = "Try user '#{sample_user.login}' with password '#{sample_user.password}' to get started." if sample_user
  end

  def authenticate
    @user = User.find_by_login(params[:user][:login])
    if @user and @user.password == params[:user][:password]
      session[:user] = @user.id
      dest = params[:dest] || dashboard_path
      redirect_to dest
    else
      flash[:notice] = "Wrong username/password combination"
      redirect_to :action => :login
    end
  end

  def logout
    session.delete(:user)
  end

  def register
    @user = User.new
  end

  def register_user
    @user = User.find_by_login(params[:user][:login])
    if @user.nil?
      @user = User.create(params[:user])
      session[:user] = @user.id
      dest = params[:dest] || root_url
      redirect_to dest
    else
      flash[:notice] = "Could not create user - user name already taken"
      render :register
    end
  end

  protected

  def random_user
    User.find(:first, :offset => rand(User.count))
  end

end
