class RemoveStartTimeToSchedule02 < ActiveRecord::Migration[5.2]
  def change
    remove_column :schedules, :start_time
  end
end
