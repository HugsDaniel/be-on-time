class ChangeTypesInItineraries < ActiveRecord::Migration[6.0]
  def change
    remove_column :itineraries, :departing_time, :time
    remove_column :itineraries, :arrival_time, :time

    add_column :itineraries, :departing_time, :datetime
    add_column :itineraries, :arrival_time, :datetime
    add_column :itinerary_buses, :departing_time, :datetime
    add_column :itinerary_buses, :arrival_time, :datetime
  end
end
