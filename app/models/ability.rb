class Ability
  include CanCan::Ability

  def initialize(user = nil)
    
    can :read, [Profile, Status]

    if user.present?

      can :update, Profile, :id => user.profile.id
      
    end
      
    
  end
end