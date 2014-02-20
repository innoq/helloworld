class ProfilesController < ApplicationController
  respond_to :html, :json

  # skip_before_filter :check_login, :only => [:show, :private] # private will deal with not loggedin users itself
  # re-enabled login to prevent google for indexing profiles
  def show
    user = User.find(params[:id])
    @profile = Profile.where(:user_id => user.id).first!
    authorize! :show, @profile
    respond_with @profile
  end

  def private
    user = User.find(params[:id])
    @profile = Profile.where(:user_id => user.id).first!
    if can?(:show_private, @profile)
      respond_with @profile
    else
      redirect_to profile_url(params[:id])
    end
  end

  def edit
    user = User.find(params[:id])
    @profile = Profile.where(:user_id => user.id).first!
    authorize! :edit, @profile

    @profile.ensure_addresses
    @profile.ensure_all_profile_attributes
    respond_with @profile
  end

  def update
    user = User.find(params[:id])
    @profile = Profile.where(:user_id => user.id).first!
    authorize! :edit, @profile

    (params[:profile] ||= {}).stringify_keys!
    ["business_address_attributes", "private_address_attributes"].each do |rel| # detete empty adress fields
      params[:profile][rel] = (params[:profile][rel] || {}).stringify_keys.reject do |key, value|
        value.blank?
      end

      if params[:profile][rel].keys == ['id']  && params[:profile][rel]['id'].present? # There is nothing left of an existing record => Delete it!
        params[:profile][rel]['_destroy'] = true
      elsif params[:profile][rel].keys == [] # There was nothing and there is noting... do nothing...
        params[:profile].delete(rel)
      end

    end

    if @profile.update_attributes(params[:profile])
      redirect_to private_profile_url(@profile)
    else
      @profile.ensure_addresses
      @profile.ensure_all_profile_attributes
      render :edit
    end

  end

end
