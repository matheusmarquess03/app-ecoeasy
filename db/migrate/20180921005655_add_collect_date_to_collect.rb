class AddCollectDateToCollect < ActiveRecord::Migration[5.2]
  def change
    add_column :collects, :collect_date, :datetime
  end
end
