class AddSalesOrderCodeToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :sales_order_last_number, :integer, :default => 10000
    add_column :settings, :sales_order_code, :string, :default => "SO"
  end


  def self.down
    remove_column :settings, :sales_order_code
  end
end
