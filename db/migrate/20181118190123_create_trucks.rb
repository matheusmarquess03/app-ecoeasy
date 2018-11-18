class CreateTrucks < ActiveRecord::Migration[5.2]
  def change
    create_table :trucks do |t|
      t.string :brand
      t.string :model
      t.string :manufacture_year
      t.string :color
      t.string :plate_number
      t.string :chassis_number
      t.string :renavam_number
      t.string :registration_number
      t.string :maximum_load
      t.string :m_3
      t.string :axles_number

      t.timestamps
    end
  end
end
