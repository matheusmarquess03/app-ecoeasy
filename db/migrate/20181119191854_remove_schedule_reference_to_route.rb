class RemoveScheduleReferenceToRoute < ActiveRecord::Migration[5.2]
  def change
    remove_column :routes, :schedule_id
  end
end
