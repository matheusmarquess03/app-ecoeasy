class RemoveUserFromCollects < ActiveRecord::Migration[5.2]
  def change
    remove_reference :collects, :user, foreign_key: true
  end
end
