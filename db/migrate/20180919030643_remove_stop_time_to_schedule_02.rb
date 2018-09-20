class RemoveStopTimeToSchedule02 < ActiveRecord::Migration[5.2]
  def change
    remove_column :schedules, :stop_time
  end
end
