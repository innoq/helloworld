require 'net/http/purge'
    
class StatusesController < ApplicationController

  skip_before_filter :check_login, :only => [:index]

  def index
    authorize! :show, Status

    # Waste some time
    sleep(1)

    # Load status list
    @statuses =  Status.order(Status.arel_table[:created_at].desc).
      includes(:profile).
      limit(25)

    expires_in 2.minutes, :public => true
      
  end

  def create
    authorize! :create, Status
        
    @status = Status.create(params[:status])
    @status.profile_id = current_user.profile.id

    if (@status.save) # Everything was fine

      # Purge the reverse proxy
      # Net::HTTP.new("localhost", "8080").request(Net::HTTP::Purge.new(statuses_path), "")

      redirect_to statuses_url # This URL is beeing cached

    else # Something went wrong

      flash[:error] = "Could not publish your status update"
      redirect_to statuses_url(:error => 1) # This URL won't be cached

    end
    
  end

end
