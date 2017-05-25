class DemesController < ApplicationController
  def show
    deme_id = params[:id]
    @deme = Deme.find(deme_id)
    @generationStats = @deme.generation_stats
  end
end
