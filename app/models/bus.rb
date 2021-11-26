class Bus < ApplicationRecord
  has_many :itinerary_buses, dependent: :destroy
end
