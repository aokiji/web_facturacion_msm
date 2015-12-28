class Factura < ActiveRecord::Base
  belongs_to :cliente
  has_many :items, :as => :order
  
  accepts_nested_attributes_for :cliente, :items
  
  validates :number, :uniqueness => true, :numericality => true
  validates :cliente, :presence => true
  
  before_validation :set_default_values
  before_save :calculate_subtotal
  after_initialize :set_default_values
  
  IMPUESTO = GlobalConfiguration.impuesto
  MSM_INFO = [ "Carretera del Morche 100", "El Morche , Malaga  29793", "Tel. 952968184, Fax 952968184", "VICTOR HUGO DE LOS SANTOS FORNI", "N.I.F. 54234379-B"]
  
  def total
    total = subtotal + impuesto_subtotal
  end
  
  def impuesto_subtotal
    (subtotal*impuesto/100.0).to_d.round(2, BigDecimal::ROUND_UP)
  end
  
  private
  def set_default_values
    self.number||= (Factura.maximum(:number) || 0)+1
    self.subtotal||= 0
    self.impuesto||=IMPUESTO
  end
  def calculate_subtotal
    self.subtotal = items.reduce(0) do |sum, item|
      sum + item.total
    end
  end
end
