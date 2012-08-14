class CreateProductUomItems < ActiveRecord::Migration
  def self.up
    create_table :product_uom_items do |t|
      t.integer :product_uom_id, :null => false
      t.integer :product_id, :null => false
      t.string :barcode, :limit => 45
      t.decimal :conversion, :precision => 12, :scale => 2, :default => 1.00

      t.timestamps
    end
    add_index :product_uom_items, :product_uom_id
    add_index :product_uom_items, :product_id
  end

  def self.down
    drop_table :product_uom_items
  end
end
