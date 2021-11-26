class BusStop < ApplicationRecord
  belongs_to :route
  has_many :buses, through: :route

  geocoded_by :longitude
  geocoded_by :latitude
end
