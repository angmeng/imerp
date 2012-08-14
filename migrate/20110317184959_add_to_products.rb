class AddToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :starred, :boolean, :default => false
  end

  def self.down
     remove_column :products, :starred
  end
end
