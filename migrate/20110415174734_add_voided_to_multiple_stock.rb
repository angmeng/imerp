class AddVoidedToMultipleStock < ActiveRecord::Migration

  def self.up
    add_column :stock_disposals, :voided, :boolean, :default => false
    add_column :stock_adjustments, :voided, :boolean, :default => false
    add_column :stock_transfers, :voided, :boolean, :default => false


    add_index :stock_disposals, :voided
    add_index :stock_adjustments, :voided
    add_index :stock_transfers, :voided
  end

  def self.down

    remove_index :stock_disposals, :voided
    remove_index :stock_adjustments, :voided
    remove_index :stock_transfers, :voided
    remove_column :stock_disposals, :voided
    remove_column :stock_adjustments, :voided
    remove_column :stock_transfers, :voided

  end
end
