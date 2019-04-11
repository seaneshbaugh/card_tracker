# frozen_string_literal: true

class RemoveAuthenticationTokenFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :authentication_token, :string
  end
end
