class CreateItineraryBuses < ActiveRecord::Migration[6.0]
  def change
    create_table :itinerary_buses do |t|
      t.references :itinerary, null: false, foreign_key: true
      t.references :bus, null: false, foreign_key: true
      t.string :starting_point
      t.string :end_point

      t.timestamps
    end
  end
end
