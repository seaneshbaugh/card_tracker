# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username email])
  end

  private

  def after_sign_out_path_for(_resource_or_scope)
    root_url
  end
end
