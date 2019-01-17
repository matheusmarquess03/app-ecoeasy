class AddClientIdToEvidence < ActiveRecord::Migration[5.2]
  def change
    add_column :evidences, :client_id, :integer
  end
end
