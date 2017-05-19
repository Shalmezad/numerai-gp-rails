class ProgramsController < ApplicationController
  def index
    deme_id = params[:deme_id]
    @programs = Program.where(:deme_id => deme_id)
  end
end
