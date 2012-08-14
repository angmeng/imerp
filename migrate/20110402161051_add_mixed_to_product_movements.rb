class AddMixedToProductMovements < ActiveRecord::Migration
  def self.up
    add_column :product_movements, :mixed, :boolean, :default => false
    add_column :product_virtual_movements, :mixed, :boolean, :default => false
    add_index :product_movements, :mixed
    add_index :product_virtual_movements, :mixed
  end

  def self.down
    remove_index :product_movements, :mixed
    remove_index :product_virtual_movements, :mixed
    remove_column :product_movements, :mixed
    remove_column :product_virtual_movements, :mixed
  end
end
