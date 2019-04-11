# frozen_string_literal: true

class ChangeUserSignInIps < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        remove_index :users, :current_sign_in_ip
        remove_index :users, :last_sign_in_ip

        change_column :users, :current_sign_in_ip, 'inet USING CAST(current_sign_in_ip AS inet)'
        change_column :users, :last_sign_in_ip, 'inet USING CAST(last_sign_in_ip AS inet)'
      end

      dir.down do
        change_column :users, :current_sign_in_ip, :string
        change_column :users, :last_sign_in_ip, :string

        add_index :users, :current_sign_in_ip
        add_index :users, :last_sign_in_ip
      end
    end
  end
end
