class AddRoutesReferenceToAddress < ActiveRecord::Migration[5.2]
  def change
    add_reference :addresses, :route, foreign_key: true
  end
end
