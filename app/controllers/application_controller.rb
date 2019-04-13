# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery

  private

  def after_sign_out_path_for(_resource_or_scope)
    root_url
  end
end
