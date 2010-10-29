class ProfilesController < ApplicationController
  respond_to :html, :json

  def show
    @profile = Profile.find(params[:id])
    authorize! :show, @profile
    respond_with @profile
  end

  def private
    @profile = Profile.find(params[:id])
    if can?(:show_private, @profile)
      respond_with @profile
    else
      redirect_to profile_url(params[:id])
    end
  end

  def edit
    @profile = Profile.find(params[:id])
    authorize! :edit, @profile

    @profile.ensure_addresses
    @profile.ensure_all_profile_attributes
    respond_with @profile
  end

  def update
    @profile = Profile.find(params[:id])
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
