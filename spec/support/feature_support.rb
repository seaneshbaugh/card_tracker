module FeatureSupport
  include Warden::Test::Helpers

  def sign_in user = nil
    user ? @user = user : @user = create(:user)
    login_as user, :scope => :user
  end
end
