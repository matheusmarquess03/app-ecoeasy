class AddAddressReferenceToEvidence < ActiveRecord::Migration[5.2]
  def change
    add_reference :evidences, :address, foreign_key: true
  end
end
