class ContactsController < ApplicationController
  before_filter :setup_context

  def index
    @contacts = @profile.contacts.paginate :page => params[:page], 
                                           :per_page => 5,
                                           :order => 'updated_at DESC'
  end


end
