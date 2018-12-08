class AddTruckReferenceToSchedule < ActiveRecord::Migration[5.2]
  def change
    add_reference :schedules, :truck, foreign_key: true
  end
end
