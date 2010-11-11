class HomeController < ApplicationController

  skip_before_filter :check_login, :only => [:about, :header]

  def dashboard
    # Load status list
    @statuses =  Status.order(Status.arel_table[:created_at].desc).
      includes(:profile => :incoming_relations).
      where(Relation.arel_table[:source_id].eq(current_user.profile.id)).
      limit(10)
  end

  def header
    render "layouts/_header", :layout => false
  end

end
