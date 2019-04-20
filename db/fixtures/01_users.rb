# frozen_string_literal: true

User.seed(:id) do |s|
  s.id = 1
  s.username = 'bungoman'
  s.email = 'sean@seaneshbaugh.com'
  s.password = 'changeme'
  s.first_name = 'Sean'
  s.last_name = 'Eshbaugh'
end

User.where(id: 1).first.add_role(:user)
User.where(id: 1).first.add_role(:admin)
