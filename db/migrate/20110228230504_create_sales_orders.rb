class CreateSalesOrders < ActiveRecord::Migration
  def self.up
    create_table :sales_orders do |t|
      t.date :sales_order_date
      t.string :sales_order_number, :limit => 20
      t.string :remark
      t.boolean :void, :default => false
      t.integer :issued_user_id, :default => 0
      t.integer :approved_user_id, :default => 0
      t.integer :status_id, :default => 0
      t.integer :company_id, :default => 0

      t.timestamps
    end
    add_index :sales_orders, :issued_user_id
    add_index :sales_orders, :approved_user_id
    add_index :sales_orders, :status_id
    add_index :sales_orders, :company_id
  end

  def self.down
    drop_table :sales_orders
  end
end
