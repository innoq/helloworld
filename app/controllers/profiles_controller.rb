class ProfilesController < ApplicationController
  before_filter :setup_context
  respond_to :html, :json

  def show_public
    @profile = Profile.find(params[:id])
    respond_with @profile
  end

  def myprofile
    respond_with @profile
  end

end
