class Harvest < ApplicationRecord
  belongs_to :land

  # 1. Ensure fields are not empty
  validates :land_id, presence: { message: "must be selected" }
  validates :crop_type, presence: { message: "must be selected" }
  validates :planned_date, presence: true

  # 2. Amount must be a positive number
  validates :amount, presence: true, numericality: { greater_than: 0 }

  # 3. Optional: Ensure Actual Date is not before Planned Date (Logic check)
  validate :actual_date_cannot_be_in_past

  private

  def actual_date_cannot_be_in_past
    if actual_date.present? && planned_date.present? && actual_date < planned_date
      errors.add(:actual_date, "cannot be earlier than the planned date")
    end
  end
end
