class AddProtocolNumberToCollect < ActiveRecord::Migration[5.2]
  def change
    add_column :collects, :protocol_number, :string
  end
end
