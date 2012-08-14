class AddStockTransferToSetting < ActiveRecord::Migration
  def self.up
    add_column :settings, :stock_transfer_code, :string, :default => "ST"
    add_column :settings, :stock_transfer_last_number, :integer, :default => 10000
  end

  def self.down
    remove_column :settings, :stock_transfer_code
    remove_column :settings, :stock_transfer_last_number
  end
end
