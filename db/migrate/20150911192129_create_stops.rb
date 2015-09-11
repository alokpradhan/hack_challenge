class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.string :agency
      t.string :name
      t.string :code

      t.timestamps null: false
    end
  end
end
