class ContactsController < ApplicationController

  def index
    @contacts = current_user.profile.contacts.paginate :page => params[:page],
      :per_page => 6,
      :order => 'updated_at DESC'
  end


end
