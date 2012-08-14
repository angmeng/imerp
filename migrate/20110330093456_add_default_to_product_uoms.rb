class AddDefaultToProductUoms < ActiveRecord::Migration
  def self.up
    add_column :product_uoms, :default, :boolean, :default => false
    add_index  :product_uoms, :default
  end

  def self.down
    remove_index  :product_uoms, :default
    remove_column :product_uoms, :default
  end
end
