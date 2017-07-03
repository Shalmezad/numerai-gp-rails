class ExportFilesController < ApplicationController

  # GET /export_files
  def index
    @export_files = ExportFile.all
  end

end
