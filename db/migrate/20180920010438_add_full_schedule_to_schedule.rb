class AddFullScheduleToSchedule < ActiveRecord::Migration[5.2]
  def change
    add_column :schedules, :full_schedule, :boolean, default: false
  end
end
