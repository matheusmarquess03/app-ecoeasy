class DropTruckersTable < ActiveRecord::Migration[5.2]
  def up
    drop_table :truckers
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
