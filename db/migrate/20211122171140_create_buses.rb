class CreateBuses < ActiveRecord::Migration[6.0]
  def change
    create_table :buses do |t|
      t.references :line, null: false, foreign_key: true
      t.references :route, null: false, foreign_key: true
      t.boolean :agent
      t.integer :crowd_level
      t.integer :noise_level
      t.boolean :safetiness
      t.integer :cleanliness_level
      t.integer :bad_smell_level
      t.integer :star_bus_id
      t.string :star_destination
      t.string :star_line_short_name
      t.float :star_longitude
      t.float :star_latitude
      t.integer :star_line_id
      t.integer :star_direction_code

      t.timestamps
    end
  end
end
