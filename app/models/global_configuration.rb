class GlobalConfiguration < ActiveRecord::Base
  # cuando no encuentra un metodo, asume que se
  # pide el valor de una clave (siendo el nombre
  # de la clave el metodo)
  def self.method_missing(method, *args, &block)
    gc=GlobalConfiguration.where(:key => method).first
    gc.nil? ? nil : gc.value
  end
end
