class AddAgencyAndStopToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :agency, :string
    add_column :searches, :stop, :string
  end
end
