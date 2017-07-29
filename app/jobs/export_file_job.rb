class ExportFileJob < ApplicationJob
  queue_as :export

  def perform(export_file_id)
    ef = ExportFile.find(export_file_id)
    # Update it:
    ef.generate_path
    ef.status = ExportFile::STATUS[:generating]
    ef.save

    # We have our path: run.
    training_datum_ids = TrainingDatum.where.not(:data_type => "train").pluck(:id)
    n = 10

    clazz = ef.program_type.constantize
    p = clazz.new
    p.gene = ef.program
    File.open(ef.path, 'w') do |file|
      file.sync
      file.write("id,probability\n")
      training_datum_ids.each_slice(n).each do |id_subset|
        TrainingDatum.find(id_subset).each do |td|
          output = p.evaluate(td.inputs)
          file.write "#{td.n_id},#{"%1.12f" % output}\n"
        end
        GC.start
      end
    end

    ef.status = ExportFile::STATUS[:complete]
    ef.save

  end

end
