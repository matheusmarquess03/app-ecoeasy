class AddAddressReferenceToCollect < ActiveRecord::Migration[5.2]
  def change
    add_reference :collects, :address, foreign_key: true
  end
end
