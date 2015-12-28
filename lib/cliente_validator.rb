class ClienteValidator < ActiveModel::Validator
  EMPTY_CLIENTE_MSG = "No hay suficiente informacion sobre el cliente"
  
  def validate(record)
    record.errors[:base] << "No hay suficiente informacion sobre el cliente"  if record.empty?
  end
end
