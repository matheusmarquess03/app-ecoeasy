class RemoveCollectReferenceToAddress < ActiveRecord::Migration[5.2]
  def change
    remove_column :addresses, :collect_id
  end
end
