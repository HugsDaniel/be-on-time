class CreateRoutes < ActiveRecord::Migration[6.0]
  def change
    create_table :routes do |t|
      t.text :route_json
      t.string :star_route_id
      t.integer :star_line_id
      t.integer :star_direction_code
      t.references :line, null: false, foreign_key: true

      t.timestamps
    end
  end
end
