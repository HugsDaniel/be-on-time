class Itinerary < ApplicationRecord
  belongs_to :user
  has_many :itinerary_buses, dependent: :destroy
  has_many :buses, through: :itinerary_buses

  geocoded_by :starting_point
  geocoded_by :end_point
  after_validation :geocode, if: :will_save_change_to_starting_point?
  after_validation :geocode, if: :will_save_change_to_end_point?
end
