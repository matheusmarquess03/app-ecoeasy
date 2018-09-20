class AddStopTimeToSchedule < ActiveRecord::Migration[5.2]
  def change
    add_column :schedules, :stop_time, :datetime
  end
end
