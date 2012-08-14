class AddInHouseCodeToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :in_house_code, :string, :limit => 13, :null => false
  end

  def self.down
    remove_column :products, :in_house_code
  end
end
