class RemoveReferencesFromBus < ActiveRecord::Migration[6.0]
  def change
    remove_reference :buses, :line
    remove_reference :buses, :route
  end
end
