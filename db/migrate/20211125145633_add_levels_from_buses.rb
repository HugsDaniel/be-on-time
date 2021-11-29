class AddLevelsFromBuses < ActiveRecord::Migration[6.0]
  def change
    add_column :buses, :crowd_level, :boolean
    add_column :buses, :noise_level, :boolean
    add_column :buses, :cleanliness_level, :boolean
    add_column :buses, :bad_smell_level, :boolean
  end
end