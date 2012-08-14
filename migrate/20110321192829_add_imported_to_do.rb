class AddImportedToDo < ActiveRecord::Migration
def self.up
     add_column :delivery_orders, :imported, :boolean, :default => false
  end

  def self.down
     remove_column :delivery_orders, :imported
  end
end