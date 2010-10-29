class MessagesController < ApplicationController

  def index
    @messages = Message.where(:to_id => current_user.profile.id).paginate :page => params[:page],
                                                           :per_page => 5,
                                                           :order => 'updated_at DESC'
  end

end
