class AddLandfillReferenceToCollect < ActiveRecord::Migration[5.2]
  def change
    add_reference :collects, :landfill, foreign_key: true
  end
end
