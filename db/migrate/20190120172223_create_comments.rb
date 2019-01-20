class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :evidence, foreign_key: true
      t.string :comment

      t.timestamps
    end
  end
end
