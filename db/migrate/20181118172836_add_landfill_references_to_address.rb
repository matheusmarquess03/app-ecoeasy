class AddLandfillReferencesToAddress < ActiveRecord::Migration[5.2]
  def change
    add_reference :addresses, :landfill, foreign_key: true
  end
end
