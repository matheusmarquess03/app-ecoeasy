class AddCnhToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :cnh, :string
  end
end
