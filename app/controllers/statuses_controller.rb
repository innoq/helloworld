require 'net/http/purge'

class StatusesController < ApplicationController

  skip_before_filter :check_login, :only => [:index]

  def index
    authorize! :show, Status

    # Waste some time
    sleep(2)

    # Load status list
    @statuses =  Status.order(Status.arel_table[:created_at].desc).
      includes(:profile).
      limit(25)

    # # Force Varnish to store this without touching the Cache-Control header (which is for the Client)
    # response.headers['X-Reverse-Proxy-ttl'] = '120'

    # # Register this to Varnish XKey tags
    # response.headers['xkey'] = 'statuslist'
  end

  def create
    authorize! :create, Status

    @status = Status.new(params[:status])
    @status.profile_id = current_user.profile.id

    if (@status.save) # Everything was fine

      # response.headers['xkey-purge'] = 'statuslist'

      redirect_to statuses_url # This URL is beeing cached

    else # Something went wrong

      flash[:error] = "Could not publish your status update"
      redirect_to statuses_url(:error => 1) # This URL won't be cached

    end

  end

end
