class GenerationStatsController < ApplicationController
  def index
    #@generationStats = GenerationStat.all.order("generation DESC")
    @generationStats = GenerationStat.all.order("created_at DESC")
  end
end
