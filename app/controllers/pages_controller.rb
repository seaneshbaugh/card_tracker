class PagesController < ApplicationController
  def index
    @new_user = User.new
  end

  def show
    begin
      render params[:id]
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
