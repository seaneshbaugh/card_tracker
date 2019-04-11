# frozen_string_literal: true

class ChangeUsersSignInCountNullConstraint < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :sign_in_count, false
  end
end
