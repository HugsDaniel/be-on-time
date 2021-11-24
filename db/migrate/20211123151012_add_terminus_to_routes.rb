class AddTerminusToRoutes < ActiveRecord::Migration[6.0]
  def change
    add_column :routes, :departure_stop, :string
    add_column :routes, :arrival_stop, :string
  end
end
