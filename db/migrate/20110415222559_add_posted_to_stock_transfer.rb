class AddPostedToStockTransfer < ActiveRecord::Migration
 def self.up
    add_column :stock_transfers, :posted, :boolean, :default => false
    add_index :stock_transfers, :posted

  end

  def self.down
    remove_index :stock_transfers, :posted
    remove_column :stock_transfers, :posted


  end
end
