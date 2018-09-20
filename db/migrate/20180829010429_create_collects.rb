class CreateCollects < ActiveRecord::Migration[5.2]
  def change
    create_table :collects do |t|
      t.integer :status
      t.integer :type_collect
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
