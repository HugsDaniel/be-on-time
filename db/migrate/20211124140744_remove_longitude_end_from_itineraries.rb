class RemoveLongitudeEndFromItineraries < ActiveRecord::Migration[6.0]
  def change
    remove_column :itineraries, :longitude_end, :float
  end
end
