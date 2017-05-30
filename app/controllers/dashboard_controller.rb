class DashboardController < ApplicationController
  def index
    @demes = Deme.all.sort{|d|d.id}
  end
end
