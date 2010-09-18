module HomeHelper
  def contact_data(profile, name)
    render :partial => "contact_data", 
           :locals => { :label => name.humanize, :value => profile.send(name).value }
  end
end
