class AddFieldsToEvidence < ActiveRecord::Migration[5.2]
  def change
    add_column :evidences, :mulct_value, :decimal
  end
end
