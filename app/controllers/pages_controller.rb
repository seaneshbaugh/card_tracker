# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    @new_user = User.new
  end

  def show
    render params[:id]
  rescue
    raise ActionController::RoutingError.new('Not Found')
  end
end
