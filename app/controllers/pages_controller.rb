# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    @new_user = User.new
  end

  def show
    render params[:id]
  rescue ActionView::MissingTemplate
    raise ActionController::RoutingError, 'Not Found'
  end
end
