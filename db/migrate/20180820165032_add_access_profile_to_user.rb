class AddAccessProfileToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :access_profile, :string
  end
end
