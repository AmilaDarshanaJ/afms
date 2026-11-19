class DailyPicking < ApplicationRecord
  belongs_to :land

  before_validation :assign_unit

  validates :picked_on, presence: true
  validates :crop_type, presence: { message: "must be selected" }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :workers_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :notes, length: { maximum: 500 }
  validate  :picked_on_not_in_future

  private

  # Unit always comes from the Crop Catalog (Coconut => Nuts, Ginger => Kg ...)
  def assign_unit
    self.unit = CropType.find_by(name: crop_type)&.unit.presence || unit
  end

  def picked_on_not_in_future
    errors.add(:picked_on, "can't be in the future") if picked_on && picked_on > Date.current
  end
end