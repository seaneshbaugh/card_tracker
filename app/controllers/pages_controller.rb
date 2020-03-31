# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    @new_user = User.new
  end

  def show
    @new_user = User.new if params[:id] == 'index'

    render params[:id]
  rescue ActionView::MissingTemplate
    raise ActionController::RoutingError, 'Not Found'
  end
end
