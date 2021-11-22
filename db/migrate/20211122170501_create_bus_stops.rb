class CreateBusStops < ActiveRecord::Migration[6.0]
  def change
    create_table :bus_stops do |t|
      t.references :route, null: false, foreign_key: true
      t.string :name
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
