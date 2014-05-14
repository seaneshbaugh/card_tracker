class Ability
  include CanCan::Ability

  ROLES = {
    :read_only => 'read_only',
    :admin => 'admin',
    :sysadmin => 'sysadmin'
  }

  def initialize(user)
    user ||= User.new

    cannot :manage, :all

    case user.role
    when ROLES[:sysadmin] then
      can :manage, :all
    when ROLES[:admin] then
      can :manage, Admin
      can :manage, CardBlockType
      can :manage, CardBlock
      can :manage, CardSet
      can :manage, Card
      can :manage, Collection
      can [:read, :create], User

      can [:update, :destroy], User do |u|
        Rails.logger.info u.inspect
        Rails.logger.info u.role
        Rails.logger.info u.role != ROLES[:sysadmin]

        u.role != ROLES[:sysadmin]
      end
    when ROLES[:read_only] then
      cannot :read, :all
    else
      cannot :read, :all
    end
  end

  def self.valid_roles(user)
    roles = {}

    if user.role == ROLES[:admin]
      roles = ROLES.reject { |key, _| key == :sysadmin }
    elsif user.role == ROLES[:sysadmin]
      roles = ROLES
    end

    roles
  end
end
