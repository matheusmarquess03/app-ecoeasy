class AddEvidenceTypeToEvidence < ActiveRecord::Migration[5.2]
  def change
    add_column :evidences, :evidence_type, :integer
  end
end
