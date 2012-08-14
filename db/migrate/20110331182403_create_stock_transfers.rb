class CreateStockTransfers < ActiveRecord::Migration
  def self.up
    create_table :stock_transfers do |t|
      t.string :stock_transfer_number, :limit => 20
      t.date :stock_transfer_date
      t.string :remark
      t.integer :user_id, :default => 0

      t.timestamps
    end
      add_index :stock_transfers, :user_id
  end

  def self.down
    drop_table :stock_transfers
  end
end
