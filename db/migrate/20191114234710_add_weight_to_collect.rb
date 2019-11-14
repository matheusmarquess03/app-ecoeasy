class AddWeightToCollect < ActiveRecord::Migration[5.2]
  def change
    add_column :collects, :weight, :decimal
  end
end
