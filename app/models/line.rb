class Line < ApplicationRecord
  has_many :routes
  has_many :buses
end
