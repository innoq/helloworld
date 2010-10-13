module HomeHelper
  def contact_data(profile, name)
    if profile.send(name)
      render "contact_data", :label => name.humanize, :value => profile.send(name).value
    end
  end
end
