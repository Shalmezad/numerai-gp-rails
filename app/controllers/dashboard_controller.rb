class DashboardController < ApplicationController
  def index
    show_all = params[:show_all] || false
    if show_all
      @demes = Deme.order("best_log_loss asc")
    else
      @demes = Deme.where(:stop => false).order("best_log_loss asc")
    end
  end
end
