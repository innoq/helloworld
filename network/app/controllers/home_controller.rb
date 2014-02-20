class HomeController < ApplicationController

  skip_before_filter :check_login, :only => [:about, :header]

  def dashboard
    my_contact_ids = current_user.profile.relations.where(Relation.arel_table[:accepted].eq(true)).map(&:destination_id)

    # Load status list
    @statuses =  []

    @contacts_of_contacts = Profile.
      includes(:incoming_relations).
      where(Relation.arel_table[:source_id].in(my_contact_ids)).
      where(Profile.arel_table[:id].not_in(my_contact_ids + [current_user.profile.id])).
      order("random()").
      limit(10)

    @unaccepted_contacts = current_user.profile.relations.not_accepted.map(&:destination)
  end

  def header
    render "layouts/_header", :layout => false
  end

end
