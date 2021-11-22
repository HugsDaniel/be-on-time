class CreateItineraries < ActiveRecord::Migration[6.0]
  def change
    create_table :itineraries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :starting_point
      t.string :end_point
      t.time :departing_time
      t.time :arrival_time
      t.boolean :favorite

      t.timestamps
    end
  end
end
