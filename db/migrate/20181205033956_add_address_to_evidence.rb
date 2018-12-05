class AddAddressToEvidence < ActiveRecord::Migration[5.2]
  def change
    add_column :evidences, :full_address, :string
  end
end
