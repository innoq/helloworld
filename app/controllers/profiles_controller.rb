class ProfilesController < ApplicationController
  before_filter :authenticate, :only => 'admin'
  before_filter :setup_context, :only => 'myprofile'
  respond_to :html, :json

  def show_public
    @profile = Profile.find(params[:id])
    respond_with @profile
  end

  def show
    @profile = Profile.find(params[:id])
    @contacts = @profile.contacts
    respond_with @profile
  end

  def myprofile
    respond_with @profile
  end

  def admin
  end

  def logout
    render(:status => 401)
  end


end
