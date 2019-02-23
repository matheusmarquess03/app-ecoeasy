class AddStatusToTemplateContestation < ActiveRecord::Migration[5.2]
  def change
    add_column :template_contestations, :status, :integer, default: 1
  end
end
