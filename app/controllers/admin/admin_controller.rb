require 'rails/application/route_inspector'

class Admin::AdminController < ApplicationController
  before_filter :authenticate_user!

  layout 'admin'

  authorize_resource

  def index
  end
end
