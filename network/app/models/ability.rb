class Ability
  include CanCan::Ability

  def initialize(user = nil)
    
    can :read, [Profile, Status]

    if user.present?

      can :update, Profile, :id => user.profile.id

      can :show_private, Profile do |profile|
        profile.user_id == user.id || profile.relations.select{|r| r.destination_id == user.profile.id && r.accepted}.any?
      end

      can [:read, :create], Status
      
    end
      

  end
end