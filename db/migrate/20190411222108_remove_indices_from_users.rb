# frozen_string_literal: true

class RemoveIndicesFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_index :users, :encrypted_password
    remove_index :users, :role
    remove_index :users, :first_name
    remove_index :users, :last_name
    remove_index :users, :reset_password_token
    add_index :users, :reset_password_token, unique: true
    remove_index :users, :reset_password_sent_at
    remove_index :users, :sign_in_count
    remove_index :users, :current_sign_in_at
    remove_index :users, :last_sign_in_at
    remove_index :users, :confirmation_token
    add_index :users, :confirmation_token, unique: true
    remove_index :users, :confirmed_at
    remove_index :users, :confirmation_sent_at
    remove_index :users, :unconfirmed_email
    remove_index :users, :failed_attempts
    remove_index :users, :unlock_token
    add_index :users, :unlock_token, unique: true
    remove_index :users, :locked_at
    remove_index :users, :authentication_token
    remove_index :users, :created_at
    remove_index :users, :updated_at
  end
end
