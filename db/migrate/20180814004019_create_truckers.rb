class CreateTruckers < ActiveRecord::Migration[5.2]
  def change
    create_table :truckers do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
