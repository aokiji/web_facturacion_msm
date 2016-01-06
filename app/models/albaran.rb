class Albaran < ActiveRecord::Base
  belongs_to :cliente
  has_many :items, :as => :order, dependent: :destroy
  
  accepts_nested_attributes_for :cliente, :items
  
  validates :number, :uniqueness => true, :numericality => true
  validates :cliente, :presence => true
  
  before_validation :set_default_values
  before_save :calculate_total
  after_initialize :set_default_values
  
  IMPUESTO = GlobalConfiguration.impuesto
  MSM_INFO = [ "Carretera del Morche 200", "El Morche , Malaga  29793", "Tel. 952968184, Fax 952968184", "VICTOR HUGO DE LOS SANTOS FORNI", "N.I.F. 54234379-B"]
  
  private
  def set_default_values
    self.number||= (Albaran.maximum(:number) || 0)+1
    self.total||= 0
  end
  def calculate_total
    self.total = items.reduce(0) do |sum, item|
      sum + item.total
    end
  end
end
