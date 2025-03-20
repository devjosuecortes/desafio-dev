class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    render :show, status: :ok
  end
end
