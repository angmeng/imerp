class AddCityIdToCustomerSupplierTransportSalesman < ActiveRecord::Migration
  def self.up
    add_column :customers, :city_id,:integer
    add_index :customers, :city_id

     add_column :suppliers, :city_id,:integer
    add_index :suppliers, :city_id

     add_column :transports, :city_id,:integer
    add_index :transports, :city_id

     add_column :salesmen, :city_id,:integer
    add_index :salesmen, :city_id
  end

  def self.down
     remove_column :customers, :city_id
    remove_index :customers, :city_id

    remove_column :suppliers, :city_id
    remove_index :suppliers, :city_id

    remove_column :transports, :city_id
    remove_index :transports, :city_id

    remove_column :salesmen, :city_id
    remove_index :salesmen, :city_id

  end
end