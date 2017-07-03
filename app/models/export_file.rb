class ExportFile < ApplicationRecord
  STATUS = {
    :queued => "Queued",
    :generating => "Generating",
    :complete => "Complete"
  }
end
