class AddRouteToItineraries < ActiveRecord::Migration[6.0]
  def change
    add_column :itineraries, :route, :string
  end
end
