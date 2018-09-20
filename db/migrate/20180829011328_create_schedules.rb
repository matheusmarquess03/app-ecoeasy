class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.date :work_day
      t.string :work_shift
      t.time :start_time
      t.time :stop_time

      t.timestamps
    end
  end
end
