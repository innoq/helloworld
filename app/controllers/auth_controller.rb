class AuthController < ApplicationController
  # Note: this implementation is a security nightmare 
  # and NOT intended for production use.

  def random_user
    User.find(:first, :offset => rand(User.count))
  end

  def login
    @user = User.new
    @dest ||= dashboard_path
    sample_user = random_user
    @hint = "Try user '#{sample_user.login}' with password '#{sample_user.password}' to get started."
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
      redirect_to :action => :register
    end
  end

end
