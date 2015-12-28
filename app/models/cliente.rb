class Cliente < ActiveRecord::Base
  has_many :facturas, :dependent => :destroy
  
  validates :email, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }, :unless => lambda {email.nil? || email.empty?}
  validates_with ClienteValidator
  
  ATTR_ORDER = ['nombre', 'apellidos', 'direccion', 'ciudad', 'provincia', 'telefono', 'cif']
  
  # check empty client
  def empty?
    (nombre.blank?) && (apellidos.blank?) && (direccion.blank?) && (telefono.blank?) && (nif.blank?)
  end
  
  def to_s
    string = []
    string<< nombre unless nombre.blank?
    string<< apellidos unless apellidos.blank?
    string<< direccion if string.blank? and !direccion.blank?
    string<< "N.I.F. #{nif}" if string.blank? and !nif.blank?
    string.join(' ')
  end
  
  # returns all object attributes excluding those that are blank or private (id)
  def non_empty_attr
    attributes.reject {|x,y| x == 'id' or y.blank?}
  end
  
  def sorted_non_empty_attr
    eval_func = lambda {|x| ATTR_ORDER.index(x) || ATTR_ORDER.size}
    non_empty_attr.sort {|x,y| eval_func.call(x[0]) <=> eval_func.call(y[0])}
  end
end
