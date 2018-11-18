class AddTruckTypeToTruck < ActiveRecord::Migration[5.2]
  def change
    add_column :trucks, :truck_type, :integer
  end
end
