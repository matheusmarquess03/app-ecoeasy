class AddCordenationToEvidence < ActiveRecord::Migration[5.2]
  def change
    add_column :evidences, :latitude, :decimal
    add_column :evidences, :longitude, :decimal
  end
end
