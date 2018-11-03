class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      grant_admin_abilities
    elsif user.super_admin?
      grant_super_admin_abilities
    end
  end

  private

  def grant_admin_abilities
    can :read, User
    can :manage, User, user_type: [:member, :lecturer, :admin]
  end

  def grant_super_admin_abilities
    grant_admin_abilities

    can :manage, User, user_type: [:super_admin]
  end
end
