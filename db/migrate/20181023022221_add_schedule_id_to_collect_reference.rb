class AddScheduleIdToCollectReference < ActiveRecord::Migration[5.2]
  def change
    add_reference :collects, :schedule, foreign_key: true
  end
end
