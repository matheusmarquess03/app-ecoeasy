class AddAddressToContract < ActiveRecord::Migration[5.2]
  def change
    add_column :contracts, :address, :string
  end
end
