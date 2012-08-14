class CreateProductCostings < ActiveRecord::Migration
  def self.up
    create_table :product_costings do |t|
      t.integer :product_id, :null => false
      t.integer :product_uom_id, :null => false
      t.integer :quantity, :default => 0
      t.decimal :cost, :default => 0.000, :precision => 10, :scale => 3

      t.timestamps
    end
    add_index :product_costings, :product_id, :product_uom_id
  end

  def self.down
    drop_table :product_costings
  end
end
