class CreateJoinTableCollectUser < ActiveRecord::Migration[5.2]
  def change
    create_join_table :collects, :users do |t|
      t.index [:collect_id, :user_id]
      t.index [:user_id, :collect_id]
    end
  end
end
