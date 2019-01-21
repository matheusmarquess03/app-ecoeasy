class AddProtocolNumberToEvidence < ActiveRecord::Migration[5.2]
  def change
    add_column :evidences, :protocol_number, :string
  end
end
