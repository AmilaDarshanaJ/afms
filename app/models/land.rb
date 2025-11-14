class Land < ApplicationRecord
  has_many :harvests
  has_many :activities
end
