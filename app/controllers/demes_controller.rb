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
    CreateDemeJob.perform_later(params[:deme][:max_program_size].to_i, params[:deme][:program_type])
    redirect_to "/dashboard"
  end

  def stop
    deme_id = params[:id]
    @deme = Deme.find(deme_id)
    @deme.stop_run
    redirect_to "/dashboard"
  end
end
