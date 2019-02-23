class CreateTemplateContestations < ActiveRecord::Migration[5.2]
  def change
    create_table :template_contestations do |t|

      t.timestamps
    end
  end
end
