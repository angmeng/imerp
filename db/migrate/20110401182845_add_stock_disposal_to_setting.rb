class AddStockDisposalToSetting < ActiveRecord::Migration
  def self.up
    add_column :settings, :stock_disposal_code, :string, :default => "SD"
    add_column :settings, :stock_disposal_last_number, :integer, :default => 10000
  end

  def self.down
    remove_column :settings, :stock_disposal_code
    remove_column :settings, :stock_disposal_last_number
  end
end


 