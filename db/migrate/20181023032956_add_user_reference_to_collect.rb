class AddUserReferenceToCollect < ActiveRecord::Migration[5.2]
  def change
    add_reference :collects, :user, foreign_key: true
  end
end
