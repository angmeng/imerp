class CreateProductVirtualMovements < ActiveRecord::Migration
  def self.up
    create_table :product_virtual_movements do |t|
      t.date :movement_date
      t.references :virtual_movement, :polymorphic => true
      t.string :description
      t.integer :product_id
      t.integer :product_uom_id
      t.integer :stock_location_id
      t.integer :quantity
      t.integer :user_id

      t.timestamps
    end
    add_index :product_virtual_movements, :user_id
    add_index :product_virtual_movements, :virtual_movement_id
    add_index :product_virtual_movements, :product_id
    add_index :product_virtual_movements, :product_uom_id
    add_index :product_virtual_movements, :stock_location_id
  end

  def self.down
    drop_table :product_virtual_movements
  end
end
