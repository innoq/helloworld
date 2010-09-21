class MessagesController < ApplicationController
  before_filter :setup_context

  def index
    @messages = Message.where(:to_id => @profile.id).paginate :page => params[:page], 
                                                           :per_page => 5,
                                                           :order => 'updated_at DESC'
  end

end
