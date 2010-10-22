class ProfilesController < ApplicationController
  respond_to :html, :json

  def show
    @profile = Profile.find(params[:id])
    respond_with @profile
  end

  def private
    @profile = Profile.find(params[:id])
    respond_with @profile
  end

end
