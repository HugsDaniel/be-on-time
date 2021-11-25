class RemoveBadSmellLevelFromBuses < ActiveRecord::Migration[6.0]

  def up
    change_table :buses do |t|
      t.change :crowd_level, :integer
      t.change :noise_level, :integer
      t.change :cleanliness_level, :integer
      t.change :bad_smell_level, :integer
    end
  end

  def down
    change_table :buses do |t|
      t.change :crowd_level, :boolean
      t.change :noise_level, :boolean
      t.change :cleanliness_level, :boolean
      t.change :bad_smell_level, :boolean
    end
end
