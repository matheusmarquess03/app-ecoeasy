class RemoveStartTimeToSchedule < ActiveRecord::Migration[5.2]
  def change
    remove_column :schedules, :start_time
  end
end
