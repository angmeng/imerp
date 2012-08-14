class AddDoCodeToSetting < ActiveRecord::Migration
  def self.up
    add_column :settings, :delivery_order_code, :string, :default => "DO"
    add_column :settings, :delivery_order_last_number, :integer, :default => 10000
  end

  def self.down
    remove_column :settings, :delivery_order_code
    remove_column :settings, :delivery_order_last_number
  end
end
