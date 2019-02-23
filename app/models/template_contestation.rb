class TemplateContestation < ApplicationRecord
  # Callbacks
  before_create  :change_default_template
  before_destroy :set_default_template

  # Associations
  has_one_attached :file

  # Enuns
  enum status: %i[unactive active]

  private

  def change_default_template
    olds_templates = TemplateContestation.active
    olds_templates.map { |template| template.unactive! }
  end

  def set_default_template
    TemplateContestation.last(2).first&.active!
  end
end
