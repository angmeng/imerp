class AddSettingsToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :purchase_requisition_last_number, :integer, :default => 10000
    add_column :settings, :purchase_requisition_code, :string, :default => "PR"
    add_column :settings, :purchase_order_last_number, :integer, :default => 10000
    add_column :settings, :purchase_order_code, :string, :default => "PO"
    add_column :settings, :invoice_last_number, :integer, :default => 10000
    add_column :settings, :invoice_code, :string, :default => "INV"
    add_column :settings, :grn_last_number, :integer, :default => 10000
    add_column :settings, :grn_code, :string, :default => "GRN"
  end

  def self.down
    remove_column :settings, :grn_code
    remove_column :settings, :grn_last_number
    remove_column :settings, :invoice_code
    remove_column :settings, :invoice_last_number
    remove_column :settings, :purchase_order_code
    remove_column :settings, :purchase_order_last_number
    remove_column :settings, :purchase_requisition_code
    remove_column :settings, :purchase_requisition_last_number
  end
end
