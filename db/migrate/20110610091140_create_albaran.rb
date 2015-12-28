class CreateAlbaran < ActiveRecord::Migration
  def self.up
    create_table :albarans do |t|
      t.date :created_at, :null => false
      t.references :cliente, :null => false
      t.integer :number, :null => false
      t.decimal :total, :precision => 8, :scale => 2, :null => false
    end 
  end

  def self.down
    drop_table :albarans
  end
end
