require 'csv'

class Activity < ApplicationRecord
  # ... existing relationships ...
  belongs_to :land # ensuring this exists for the export

  def self.to_csv
    headers = ['ID', 'Land Name', 'Start Date', 'Summary', 'Status']

    CSV.generate(headers: true) do |csv|
      csv << headers

      all.each do |activity|
        csv << [
          activity.id,
          activity.land&.name || "Unassigned",
          activity.start_date&.strftime("%Y-%m-%d"),
          activity.summary,
          activity.status.to_s.humanize
        ]
      end
    end
  end
end