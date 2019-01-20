class AddAdminReferenceToComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :comments, :admin, foreign_key: true
  end
end
