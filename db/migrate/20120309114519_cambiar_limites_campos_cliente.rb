class CambiarLimitesCamposCliente < ActiveRecord::Migration
  def self.up
	change_column :clientes, :direccion, :string, :limit => 100 
  end

  def self.down
	change_column :clientes, :direccion, :string, :limit => 30
  end
end
