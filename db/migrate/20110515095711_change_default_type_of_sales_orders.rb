class ChangeDefaultTypeOfSalesOrders < ActiveRecord::Migration
  def self.up
    change_column_default(:sales_orders, :salesman_id, 0)
  end

  def self.down
  end
end
