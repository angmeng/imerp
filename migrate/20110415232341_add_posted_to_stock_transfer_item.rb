class AddPostedToStockTransferItem < ActiveRecord::Migration
   def self.up
    add_column :stock_transfer_items, :posted, :boolean, :default => false
    add_index :stock_transfer_items, :posted

  end

  def self.down
    remove_index :stock_transfer_items, :posted
    remove_column :stock_transfer_items, :posted


  end
end