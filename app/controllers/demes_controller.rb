class DemesController < ApplicationController
  def show
    deme_id = params[:id]
    @deme = Deme.find(deme_id)
    @generationStats = @deme.generation_stats
  end


  def new
    @deme = Deme.new
  end

  def create
    # We have our params:
    d = params[:deme]
    d = d.permit(:max_size, :program_type)
    d = d.to_hash
    CreateDemeJob.perform_later(d)
    redirect_to "/dashboard"
  end

  def stop
    deme_id = params[:id]
    @deme = Deme.find(deme_id)
    @deme.stop_run
    redirect_to "/dashboard"
  end
end
