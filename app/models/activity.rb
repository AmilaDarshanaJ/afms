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

  # 1. Required Fields
  validates :land_id, presence: { message: "must be selected" }
  validates :status, presence: true
  validates :start_date, presence: true
  validates :summary, presence: true, length: { minimum: 5, message: "is too short (min 5 chars)" }

  # 2. Logic Check: End Date cannot be before Start Date
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "cannot be earlier than the start date")
    end
    end
end