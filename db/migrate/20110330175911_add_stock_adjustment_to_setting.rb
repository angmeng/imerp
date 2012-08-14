class AddStockAdjustmentToSetting < ActiveRecord::Migration
  def self.up
    add_column :settings, :stock_adjustment_code, :string, :default => "SA"
    add_column :settings, :stock_adjustment_last_number, :integer, :default => 10000
  end

  def self.down
    remove_column :settings, :stock_adjustment_code
    remove_column :settings, :stock_adjustment_last_number
  end
end
