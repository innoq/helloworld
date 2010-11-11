require 'net/http/purge'
    
class StatusesController < ApplicationController

  skip_before_filter :check_login, :only => [:index]

  def index
    authorize! :show, Status

    newest_status = Status.order(Status.arel_table[:created_at].desc).first
    if stale?(:etag => newest_status.id, :last_modified => newest_status.created_at)

      sleep(0.5)

      @statuses =  Status.order(Status.arel_table[:created_at].desc).
        includes(:profile).
        limit(25)

      if !params[:error]
        expires_in 1.hour, :private => false
      end
      
    end
  end

  def create
    authorize! :create, Status
        
    @status = Status.create(params[:status])
    @status.profile_id = current_user.profile.id

    if (@status.save)
      Net::HTTP.new("localhost", "8080").request(Net::HTTP::Purge.new(statuses_path), "")
      redirect_to statuses_url # This one is cached
    else
      flash[:error] = "Could not publish your status update"
      redirect_to statuses_url(:error => 1)
    end
    
  end

end
