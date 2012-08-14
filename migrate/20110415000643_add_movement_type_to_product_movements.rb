class AddMovementTypeToProductMovements < ActiveRecord::Migration
  def self.up
    add_column :product_movements, :movement_type, :string
  end

  def self.down
    remove_column :product_movements, :movement_type
  end
end
