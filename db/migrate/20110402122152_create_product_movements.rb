class CreateProductMovements < ActiveRecord::Migration
  def self.up
    create_table :product_movements do |t|
      t.date :movement_date
      t.references :movement
      t.integer :product_id
      t.integer :product_uom_id
      t.integer :stock_location_id, :default => 0
      t.integer :quantity
      t.string :description

      t.timestamps
    end
    add_index :product_movements, :product_id
    add_index :product_movements, :product_uom_id
    add_index :product_movements, :stock_location_id
    
  end

  def self.down
    drop_table :product_movements
  end
end
