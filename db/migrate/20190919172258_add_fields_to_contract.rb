class AddFieldsToContract < ActiveRecord::Migration[5.2]
  def change
    add_column :contracts, :start_date, :date
    add_column :contracts, :renewal_date, :date
    add_column :contracts, :commitment_value, :decimal
  end
end
