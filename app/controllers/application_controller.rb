class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_out_path_for(resource_or_scope)
    login_url
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message

    redirect_to root_url
  end
end
