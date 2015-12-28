class Facturacion < ActiveRecord::Migration
  def self.up
    create_table :clientes do |t|
      t.string :nombre, :limit => 30
      t.string :apellidos, :limit => 50
      t.string :email, :limit => 30
      t.string :telefono, :limit => 15
      t.string :direccion, :limit => 30
      t.string :ciudad, :limit => 20
      t.string :provincia, :limit => 20
      t.string :codigo_postal, :limit => 10
      t.string :nif, :limit => 20
    end
    
    create_table :facturas do |t|
      t.date :created_at, :null => false
      t.references :cliente, :null => false
      t.integer :number, :null => false
      t.decimal :subtotal, :precision => 8, :scale => 2, :null => false
      t.float :impuesto, :null => false
    end
    
    create_table :presupuestos do |t|
      t.date :created_at, :null => false
      t.references :cliente, :null => false
      t.integer :number, :null => false
      t.decimal :subtotal, :precision => 8, :scale => 2, :null => false
      t.float :impuesto, :null => false
    end
    
    create_table :items do |t|
      t.text :description
      t.integer :cantidad
      t.decimal :precio_unidad, :precision => 8, :scale => 2
      t.references :order, :polymorphic => true
    end
  end

  def self.down
    [:clientes, :facturas, :presupuestos, :items].each {|t| drop_table(t)}
  end
end
