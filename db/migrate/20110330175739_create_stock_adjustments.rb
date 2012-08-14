class CreateStockAdjustments < ActiveRecord::Migration
  def self.up
    create_table :stock_adjustments do |t|
      t.string :stock_adjustment_number, :limit => 20
      t.date :stock_date
      t.string :remark
      t.integer :user_id, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :stock_adjustments
  end
end
