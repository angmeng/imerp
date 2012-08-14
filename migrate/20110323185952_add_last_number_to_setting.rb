class AddLastNumberToSetting < ActiveRecord::Migration
  def self.up
    add_column :settings, :customer_credit_note_code, :string, :default => "CCN"
    add_column :settings, :customer_credit_note_last_number, :integer, :default => 10000
    add_column :settings, :customer_debit_note_code, :string, :default => "CDN"
    add_column :settings, :customer_debit_note_last_number, :integer, :default => 10000
    add_column :settings, :supplier_credit_note_code, :string, :default => "SCN"
    add_column :settings, :supplier_credit_note_last_number, :integer, :default => 10000
    add_column :settings, :supplier_debit_note_code, :string, :default => "SDN"
    add_column :settings, :supplier_debit_note_last_number, :integer, :default => 10000
  end

  def self.down
    remove_column :settings, :customer_credit_note_code
    remove_column :settings, :customer_credit_note_last_number
    remove_column :settings, :customer_debit_note_code
    remove_column :settings, :customer_debit_note_last_number
    remove_column :settings, :supplier_credit_note_code
    remove_column :settings, :supplier_credit_note_last_number
    remove_column :settings, :supplier_debit_note_code
    remove_column :settings, :supplier_debit_note_last_number
  end
end
