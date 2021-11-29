class RemoveLevelsFromBuses < ActiveRecord::Migration[6.0]
  def change
    remove_column :buses, :crowd_level
    remove_column :buses, :noise_level
    remove_column :buses, :cleanliness_level
    remove_column :buses, :bad_smell_level
  end
end
