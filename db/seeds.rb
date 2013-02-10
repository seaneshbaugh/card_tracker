%x[rake db:data:load]

load 'user.rb'

sysadmin_user = User.create({ :username => 'sysadmin', :email => 'sysadmin@cavesofkoilos.com', :password =>'verylongpassword', :role => 'sysadmin', :first_name => 'Sysadmin', :last_name => 'User' })

sysadmin_user.skip_confirmation!

sysadmin_user.save!

admin_user = User.create({ :username => 'admin', :email => 'admin@cavesofkoilos.com', :password =>'verylongpassword', :role => 'admin', :first_name => 'Admin', :last_name => 'User' })

admin_user.skip_confirmation!

admin_user.save!

read_only_user = User.create({ :username => 'read_only', :email => 'read_only@cavesofkoilos.com', :password =>'verylongpassword', :role => 'read_only', :first_name => 'Read Only', :last_name => 'User' })

read_only_user.skip_confirmation!

read_only_user.save!
