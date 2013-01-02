%x[rake db:data:load]

load 'user.rb'

users = User.all

users.each do |user|
  user.password = 'changeme'
  user.save!
end

sysadmin_user = User.create({ :username => 'sysadmin', :email => 'sysadmin@cavesofkoilos.com', :password =>'changeme', :role => 'sysadmin', :first_name => 'Sysadmin', :last_name => 'User' })

sysadmin_user.skip_confirmation!

sysadmin_user.save!

admin_user = User.create({ :username => 'admin', :email => 'admin@cavesofkoilos.com', :password =>'changeme', :role => 'admin', :first_name => 'Admin', :last_name => 'User' })

admin_user.skip_confirmation!

admin_user.save!

read_only_user = User.create({ :username => 'read_only', :email => 'read_only@cavesofkoilos.com', :password =>'changeme', :role => 'read_only', :first_name => 'Read Only', :last_name => 'User' })

read_only_user.skip_confirmation!

read_only_user.save!
