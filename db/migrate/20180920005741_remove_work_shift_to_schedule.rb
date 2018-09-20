class RemoveWorkShiftToSchedule < ActiveRecord::Migration[5.2]
  def change
    remove_column :schedules, :work_shift
  end
end
