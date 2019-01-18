class CreateContestations < ActiveRecord::Migration[5.2]
  def change
    create_table :contestations do |t|
      t.references :user, foreign_key: true
      t.references :evidence, foreign_key: true
      t.string :justification

      t.timestamps
    end
  end
end
