class AdminController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_admin, only: %i[ show ]

  def index
    @admins = Admin.all
  end

  def show
  end

  private

  def set_admin
    @admin = Admin.find(current_admin.id)
  end
end
