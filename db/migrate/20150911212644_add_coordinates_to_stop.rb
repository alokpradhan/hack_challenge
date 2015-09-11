class AddCoordinatesToStop < ActiveRecord::Migration
  def change
    add_column :stops, :latitude, :decimal
    add_column :stops, :longitude, :decimal
  end
end
