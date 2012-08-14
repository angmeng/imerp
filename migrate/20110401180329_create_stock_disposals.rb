class CreateStockDisposals < ActiveRecord::Migration
  def self.up
    create_table :stock_disposals do |t|
      t.string :stock_disposal_number, :limit => 20
      t.date :stock_disposal_date
      t.string :remark
      t.boolean :voided, :default => false
      t.boolean :posted, :default => false
      t.integer :user_id, :default => false

      t.timestamps
    end
    add_index :stock_disposals, :user_id
  end

  def self.down
    drop_table :stock_disposals
  end
end
