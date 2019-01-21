class AddStatusToEvidence < ActiveRecord::Migration[5.2]
  def change
    add_column :evidences, :status, :integer, default: 0
  end
end
