class Itinerary < ApplicationRecord
  belongs_to :user
  has_many :itinerary_buses
  has_many :buses, through: :itinerary_buses

end
