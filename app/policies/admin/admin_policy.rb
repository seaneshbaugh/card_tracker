# frozen_string_literal: true

module Admin
  class AdminPolicy
    attr_accessor :user, :record

    def initialize(user, record)
      @user = user

      @record = record
    end

    def index?
      user.has_role?(:admin)
    end

    def show?
      user.has_role?(:admin)
    end

    def create?
      user.has_role?(:admin)
    end

    def new?
      create?
    end

    def update?
      user.has_role?(:admin)
    end

    def edit?
      update?
    end

    def destroy?
      user.has_role?(:admin)
    end

    def scope
      Pundit.policy_scope!(user, record)
    end

    class Scope
      attr_reader :user, :scope

      def initialize(user, scope)
        @user = user

        @scope = scope
      end

      def resolve
        scope
      end
    end
  end
end
