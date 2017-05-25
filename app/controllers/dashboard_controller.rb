class DashboardController < ApplicationController
  def index
    @demes = Deme.all
  end
end
