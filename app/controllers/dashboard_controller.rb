class DashboardController < ApplicationController
  def index
    @demes = Deme.where(:stop => false).order("best_log_loss asc")
  end
end
