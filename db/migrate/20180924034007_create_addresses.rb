class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.references :user
      t.string :street
      t.string :number
      t.string :complement
      t.string :district
      t.string :city
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
