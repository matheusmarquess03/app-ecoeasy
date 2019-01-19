class AddInfratorCpfToEvidence < ActiveRecord::Migration[5.2]
  def change
    add_column :evidences, :citizen_cpf, :string
  end
end
