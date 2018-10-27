class AddDefaultToAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :default, :boolean
  end
end
