class AddColourToItineraries < ActiveRecord::Migration[6.0]
  def change
    add_column :itineraries, :colour, :string
  end
end
