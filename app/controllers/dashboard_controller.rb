class DashboardController < ApplicationController
  def index
    @demes = Deme.order("best_log_loss asc")
  end
end
