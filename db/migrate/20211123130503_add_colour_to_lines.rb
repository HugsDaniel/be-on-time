class AddColourToLines < ActiveRecord::Migration[6.0]
  def change
    add_column :lines, :colour, :string
  end
end
