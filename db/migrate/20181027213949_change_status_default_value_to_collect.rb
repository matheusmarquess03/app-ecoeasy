class ChangeStatusDefaultValueToCollect < ActiveRecord::Migration[5.2]
  def change
    change_column :collects, :status, :integer, :default => 'requested'
  end
end
