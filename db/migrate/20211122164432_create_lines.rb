class CreateLines < ActiveRecord::Migration[6.0]
  def change
    create_table :lines do |t|
      t.integer :star_line_id
      t.string :star_short_name
      t.string :star_long_name

      t.timestamps
    end
  end
end
