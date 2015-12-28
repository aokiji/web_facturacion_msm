class Item < ActiveRecord::Base
  belongs_to :order, :polymorphic => :true
  validates :cantidad, :numericality => {:only_integer => true}
  validates :precio_unidad, :numericality => true
  
  def total
    cantidad*precio_unidad rescue 0
  end
end
