class AddColsToStops < ActiveRecord::Migration
  def change
    add_column :stops, :route_code, :string
    add_column :stops, :direction, :string
  end
end
