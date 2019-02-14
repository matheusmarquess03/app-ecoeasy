class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value&.valid_cpf?
      record.errors[attribute] << (options[:message] || "is not an valid")
    end
  end
end
