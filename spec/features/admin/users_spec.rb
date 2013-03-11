require 'spec_helper'

describe 'admin/users' do
  context '#index' do
    it 'should display the Users index' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      visit admin_users_path

      page.body.should have_selector('#users')

      page.body.should have_content(I18n.t('activerecord.models.user').pluralize)
    end

    it 'should display a list of Users when there are Users' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      4.times do
        create(:user)
      end

      visit admin_users_path

      page.body.should have_selector('#users table')

      page.body.should_not have_content(I18n.t('messages.users.none'))
    end

    it 'should paginate the list of Users' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      35.times do
        create(:user)
      end

      visit admin_users_path

      page.body.should have_selector('#users table')

      page.body.should_not have_content(I18n.t('messages.users.none'))

      users = User.order('users.created_at ASC')

      users[0..24].each do |user|
        page.body.should have_selector('#users table tbody a', :text => user.full_name)
      end

      users[25..34].each do |user|
        page.body.should_not have_selector('#users table tbody a', :text => user.full_name)
      end
    end

    it 'should display a link to create a new user for admin users' do
      @user = create(:admin_user)

      sign_in(@user)

      visit admin_users_path

      page.body.should have_selector('a', :text => I18n.t('users.new.title'))
    end

    it 'should display a link to create a new user for sysadmin users' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      visit admin_users_path

      page.body.should have_selector('a', :text => I18n.t('users.new.title'))
    end
  end

  context '#show' do
    it 'should display the User' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      user = create(:user)

      visit admin_user_path(user)

      page.should have_selector("#user")

      page.should have_content(I18n.t('activerecord.attributes.user.first_name'))

      page.should have_content(user.first_name)

      page.should have_content(I18n.t('activerecord.attributes.user.last_name'))

      page.should have_content(user.last_name)

      page.should have_content(I18n.t('activerecord.attributes.user.email'))

      page.should have_content(user.email)

      page.should have_content(I18n.t('activerecord.attributes.user.username'))

      page.should have_content(user.username)

      page.should have_content(I18n.t('activerecord.attributes.user.created_at'))

      page.should have_content(user.created_at.strftime('%Y-%m-%d %H:%M:%S'))

      page.should have_content(I18n.t('activerecord.attributes.user.updated_at'))

      page.should have_content(user.updated_at.strftime('%Y-%m-%d %H:%M:%S'))
    end

    it 'should display a link to edit a user for admin users' do
      @user = create(:admin_user)

      sign_in(@user)

      user = create(:user)

      visit admin_user_path(user)

      page.body.should have_selector('a', :text => I18n.t('users.edit.title'))
    end

    it 'should display a link to edit a user for sysadmin users' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      user = create(:user)

      visit admin_user_path(user)

      page.body.should have_selector('a', :text => I18n.t('users.edit.title'))
    end

    it 'should display a link to delete a user for admin users' do
      @user = create(:admin_user)

      sign_in(@user)

      user = create(:user)

      visit admin_user_path(user)

      page.body.should have_selector('a', :text => I18n.t('users.delete.title'))
    end

    it 'should display a link to delete a user for sysadmin users' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      user = create(:user)

      visit admin_user_path(user)

      page.body.should have_selector('a', :text => I18n.t('users.delete.title'))
    end

    it 'should display a link to go back to the User index' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      user = create(:user)

      visit admin_user_path(user)

      page.body.should have_selector('a', :text => I18n.t('users.links.back_to_index'))
    end
  end

  context '#new' do
    it 'should display the new User form' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      visit new_admin_user_path

      page.should have_selector('#new-user')

      page.should have_selector('form#new_user')

      page.should have_selector('form#new_user input[type="text"]#user_first_name')

      page.should have_selector('form#new_user input[type="text"]#user_last_name')

      page.should have_selector('form#new_user input[type="email"]#user_email')

      page.should have_selector('form#new_user input[type="submit"]')
    end

    it 'should let an admin user create a new User' do
      @user = create(:admin_user)

      sign_in(@user)

      user = build(:user)

      User.count.should eq(1)

      visit new_admin_user_path

      fill_in 'user[first_name]', :with => user.first_name

      fill_in 'user[last_name]', :with => user.last_name

      fill_in 'user[email]', :with => user.email

      fill_in 'user[username]', :with => user.username

      fill_in 'user[password]', :with => user.password

      fill_in 'user[password_confirmation]', :with => user.password

      click_button I18n.t('helpers.submit.user.create')

      User.count.should eq(2)
    end

    it 'should let an sysadmin user create a new User' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      user = build(:user)

      User.count.should eq(1)

      visit new_admin_user_path

      fill_in 'user[first_name]', :with => user.first_name

      fill_in 'user[last_name]', :with => user.last_name

      fill_in 'user[email]', :with => user.email

      fill_in 'user[username]', :with => user.username

      fill_in 'user[password]', :with => user.password

      fill_in 'user[password_confirmation]', :with => user.password

      click_button I18n.t('helpers.submit.user.create')

      User.count.should eq(2)
    end

    it 'should display a link to go back to the User index' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      visit new_admin_user_path

      page.body.should have_selector('a', :text => I18n.t('users.links.back_to_index'))
    end
  end

  context '#edit' do
    it 'should display the edit User form' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      user = create(:user)

      visit edit_admin_user_path(user)

      page.should have_selector('#edit-user')

      page.should have_selector("form#edit_user_#{user.id}")

      page.should have_selector("form#edit_user_#{user.id} input[type='text']#user_first_name")

      page.should have_selector("form#edit_user_#{user.id} input[type='text']#user_last_name")

      page.should have_selector("form#edit_user_#{user.id} input[type='email']#user_email")

      page.should have_selector("form#edit_user_#{user.id} input[type='submit']")
    end

    it 'should let an admin user edit a User' do
      @user = create(:admin_user)

      sign_in(@user)

      user = create(:user)

      User.count.should eq(2)

      visit edit_admin_user_path(user)

      fill_in 'user[first_name]', :with => 'New First Name'

      fill_in 'user[last_name]', :with => 'New Last Name'

      fill_in 'user[email]', :with => 'newemail@test.com'

      click_button I18n.t('helpers.submit.user.update')

      User.count.should eq(2)

      updated_user = User.last

      updated_user.first_name.should_not eq(user.first_name)

      updated_user.first_name.should eq('New First Name')

      updated_user.last_name.should_not eq(user.last_name)

      updated_user.last_name.should eq('New Last Name')

      updated_user.email.should_not eq(user.email)

      updated_user.email.should eq('newemail@test.com')
    end

    it 'should let an sysadmin user edit a User' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      user = create(:user)

      User.count.should eq(2)

      visit edit_admin_user_path(user)

      fill_in 'user[first_name]', :with => 'New First Name'

      fill_in 'user[last_name]', :with => 'New Last Name'

      fill_in 'user[email]', :with => 'newemail@test.com'

      click_button I18n.t('helpers.submit.user.update')

      User.count.should eq(2)

      updated_user = User.last

      updated_user.first_name.should_not eq(user.first_name)

      updated_user.first_name.should eq('New First Name')

      updated_user.last_name.should_not eq(user.last_name)

      updated_user.last_name.should eq('New Last Name')

      updated_user.email.should_not eq(user.email)

      updated_user.email.should eq('newemail@test.com')
    end

    it 'should display a link to go back to the User index' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      user = create(:user)

      visit edit_admin_user_path(user)

      page.body.should have_selector('a', :text => I18n.t('users.links.back_to_index'))
    end
  end
end
