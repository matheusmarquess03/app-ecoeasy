class CreateSchedulesRoutes < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules_routes do |t|
      t.references :schedule, foreign_key: true
      t.references :route, foreign_key: true

      t.timestamps
    end
  end
end
