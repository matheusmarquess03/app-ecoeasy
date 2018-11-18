class CreateLandfills < ActiveRecord::Migration[5.2]
  def change
    create_table :landfills do |t|
      t.string :name

      t.timestamps
    end
  end
end
