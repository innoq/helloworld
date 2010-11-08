class StatusesController < ApplicationController

  skip_before_filter :check_login, :only => [:index]

  def index
    authorize! :show, Status

    newest_status = Status.order(Status.arel_table[:created_at].desc).first

    if stale?(:etag => newest_status.id, :last_modified => newest_status.created_at)
      @statuses =  Status.order(Status.arel_table[:created_at].desc).
        includes(:profile).
        limit(25)
      response.headers["expires"] = 1.hour.since.httpdate
    end
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
