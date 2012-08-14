class AddToSetting < ActiveRecord::Migration
  def self.up
    add_column :settings, :packing_list_code, :string, :default => "PL"
    add_column :settings, :packing_list_last_number, :integer, :default => 10000
  end

  def self.down
    remove_column :settings, :packing_list_code
    remove_column :settings, :packing_list_last_number
  end
end
