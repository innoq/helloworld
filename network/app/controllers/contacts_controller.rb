class ContactsController < ApplicationController

  def index
    @contacts = current_user.profile.relations.accepted.map(&:destination).paginate(:page => params[:page],
      :per_page => 6,
      :order => 'updated_at DESC'
    )
  end

  def create
    destination = Profile.find(params[:destination_id])
    ActiveRecord::Base.transaction do
      unless current_user.profile.relations.where(:destination_id => destination.id).any?
        current_user.profile.relations << Relation.new(:destination => destination, :accepted => true)
        current_user.profile.save!
      end
      unless destination.relations.where(:destination_id => current_user.profile.id).any?
        destination.relations << Relation.new(:destination => current_user.profile, :accepted => false)
        destination.save!
      end
    end
    redirect_to contacts_url
  end

  def update
    current_user.profile.relations.where(:destination_id => params[:id]).each do |rel|
      rel.update_attribute(:accepted, params[:accepted])
    end
    redirect_to contacts_url
  end

  def destroy
    current_user.profile.relations.where(:destination_id => params[:id]).destroy_all
    redirect_to contacts_url
  end

end
