class AddFieldsToAdmin < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :phone_number, :string
    add_column :admins, :cpf, :string
  end
end
