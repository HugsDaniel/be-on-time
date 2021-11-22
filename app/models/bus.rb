class Bus < ApplicationRecord
  belongs_to :line
  belongs_to :route
  has_many :itinerary_buses
end
