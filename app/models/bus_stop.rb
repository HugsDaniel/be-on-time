class BusStop < ApplicationRecord
  belongs_to :route
  geocoded_by :longitude
  geocoded_by :latitude
end
