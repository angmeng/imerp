class AddCostToProductMovement < ActiveRecord::Migration
  def self.up
     add_column :product_movements, :cost, :decimal, :precision => 12, :scale => 3, :default => 0.000
  end

  def self.down
     remove_column :product_movements, :cost
  end
end
