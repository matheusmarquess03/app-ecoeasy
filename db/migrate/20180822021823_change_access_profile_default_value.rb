class ChangeAccessProfileDefaultValue < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :access_profile, :integer, :default => 'customer'
  end
end
