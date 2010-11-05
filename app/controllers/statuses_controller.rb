class StatusesController < ApplicationController

  def index
    authorize! :show, Status

    @statuses =  Status.order(Status.arel_table[:created_at].desc).
      includes(:profile).
      limit(25)
  end

  def create
    authorize! :create, Status
        
    @status = Status.create(params[:status])
    @status.profile_id = current_user.profile.id
    if (!@status.save)
      flash[:error] = "Could not publish your status update"
    end

    redirect_to statuses_url
  end

end
