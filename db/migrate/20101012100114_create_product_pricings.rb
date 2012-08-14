class CreateProductPricings < ActiveRecord::Migration
  def self.up
    create_table :product_pricings do |t|
      t.integer :product_uom_item_id, :null => false
      t.integer :price_level_id, :null => false
      t.decimal :selling_price, :precision => 12, :scale => 2, :default => 0.00, :null => false

      t.timestamps
    end
    add_index :product_pricings, :product_uom_item_id
    add_index :product_pricings, :price_level_id
  end

  def self.down
    drop_table :product_pricings
  end
end
