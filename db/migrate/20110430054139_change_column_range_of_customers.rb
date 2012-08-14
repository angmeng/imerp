class ChangeColumnRangeOfCustomers < ActiveRecord::Migration
  def self.up
    change_column :customers, :address, :text
    change_column :customers, :office_contact, :string, :limit => 45
    
  end

  def self.down
  end
end
