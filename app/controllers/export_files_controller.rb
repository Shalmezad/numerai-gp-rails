class ExportFilesController < ApplicationController

  # GET /export_files
  def index
    @export_files = ExportFile.all.reverse
  end

  def create
    p = params.permit(:program, :program_type)
    @export_file = ExportFile.create(p)
    # Always start as queued:
    @export_file.status = ExportFile::STATUS[:queued]
    @export_file.save
    # Queue up the job:
    ExportFileJob.perform_later(@export_file.id)

    redirect_to action: "index"
  end

end
