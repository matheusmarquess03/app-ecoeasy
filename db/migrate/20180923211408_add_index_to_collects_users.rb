class AddIndexToCollectsUsers < ActiveRecord::Migration[5.2]
  def change
    remove_index :collects_users, [:collect_id, :user_id]
    remove_index :collects_users, [:user_id, :collect_id]
    add_index :collects_users, [:collect_id, :user_id], :unique => true
    add_index :collects_users, [:user_id, :collect_id], :unique => true
  end
end
