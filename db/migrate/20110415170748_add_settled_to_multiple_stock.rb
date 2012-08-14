class AddSettledToMultipleStock < ActiveRecord::Migration
  def self.up

    add_column :stock_disposals, :settled, :boolean, :default => false
    add_column :stock_adjustments, :settled, :boolean, :default => false
    add_column :stock_transfers, :settled, :boolean, :default => false


    add_index :stock_disposals, :settled
    add_index :stock_adjustments, :settled
    add_index :stock_transfers, :settled
  end

  def self.down

    remove_index :stock_disposals, :settled
    remove_index :stock_adjustments, :settled
    remove_index :stock_transfers, :settled
    remove_column :stock_disposals, :settled
    remove_column :stock_adjustments, :settled
    remove_column :stock_transfers, :settled

  end
end

