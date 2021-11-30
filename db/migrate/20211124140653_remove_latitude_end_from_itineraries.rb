class RemoveLatitudeEndFromItineraries < ActiveRecord::Migration[6.0]
  def change
    remove_column :itineraries, :latitude_end, :float
  end
end
