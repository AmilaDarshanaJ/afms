class Land < ApplicationRecord
  has_many :harvests
  has_many :activities


  # 1. Required Fields (Cannot be blank)
  validates :name, presence: { message: "must be provided" }
  validates :crop_type, presence: { message: "must be selected" }

  # 2. Number Validation (Must be a positive number)
  validates :extent, presence: true, numericality: { greater_than: 0 }

  # 3. Optional: Coordinate Validation (If entered, must be valid numbers)
  validates :latitude, :longitude, numericality: { allow_nil: true }

  # 4. Optional: Length limits
  validates :address, length: { maximum: 200 }
end
