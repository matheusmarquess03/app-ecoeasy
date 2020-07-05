class CreateFirebaseData < ActiveRecord::Migration[5.2]
  def change
    create_table :firebase_data do |t|
      t.date :work_day
      t.bigint :user_id
      t.bigint :truck_id
	  t.integer :has_data
      t.numeric :distance

      t.timestamps
    end
  end
end
