class ExportFile < ApplicationRecord
  STATUS = {
    :queued => "Queued",
    :generating => "Generating",
    :complete => "Complete"
  }

  def generate_path
    # public/files/something
    self.path = "public/files/#{SecureRandom.uuid}.csv"
  end

end
