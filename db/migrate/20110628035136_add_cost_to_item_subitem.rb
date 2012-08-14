class AddCostToItemSubitem < ActiveRecord::Migration
  def self.up
    add_column :pack_item_subitems, :cost, :decimal, :precision => 12, :scale => 3, :default => 0.000
  end

  def self.down
     remove_column :pack_item_subitems, :cost
  end
end
