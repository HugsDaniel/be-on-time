class Route < ApplicationRecord
  belongs_to :line
  has_many :bus_stops
  has_many :buses
end
