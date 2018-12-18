class AddPhoneToLandfill < ActiveRecord::Migration[5.2]
  def change
    add_column :landfills, :phone, :string
  end
end
