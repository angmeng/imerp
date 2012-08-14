class CreateMixedProducts < ActiveRecord::Migration
  def self.up
    create_table :mixed_products do |t|
      t.integer :parent_id, :null => false
      t.integer :product_id, :null => false
      t.decimal :quantity, :null => false, :precision => 12, :scale => 2, :default => 0.0

      t.timestamps
    end
    
    add_index :mixed_products, :parent_id
    add_index :mixed_products, :product_id
  end

  def self.down
    drop_table :mixed_products
  end
end
