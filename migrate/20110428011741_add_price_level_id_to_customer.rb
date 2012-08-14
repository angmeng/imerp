class AddPriceLevelIdToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :price_level_id,:integer
    add_index :customers, :price_level_id
  end

  def self.down
    remove_column :customers, :price_level_id
    remove_index :customers, :price_level_id
  end
end
