require 'net/http/purge'

class StatusesController < ApplicationController

  skip_before_filter :check_login, :only => [:index]
  skip_before_filter :verify_authenticity_token

  def index
    authorize! :show, Status

    # Waste some time
    sleep(2)

    # Load status list
    @statuses =  Status.order(Status.arel_table[:created_at].desc).
      includes(:profile).
      limit(25)

    # # Set `Cache-Control: max-age=3600, public`
    # response.headers['Cache-Control'] = 'max-age=3600, public'

    # # Alternatively (better):
    # use a Cache-Control ignored by the client
    response.headers['Cache-Control'] = 'max-age=0, s-maxage=3600, public'


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
