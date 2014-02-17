class Ability
  include CanCan::Ability

  def initialize(user = nil)

    can :read, Status

    if user.present?

      can [:read, :create], Status

    end

  end
end