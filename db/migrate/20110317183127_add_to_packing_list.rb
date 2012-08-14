class AddToPackingList < ActiveRecord::Migration
  def self.up
    add_column :packing_lists, :starred, :boolean, :default => false
  end

  def self.down
    remove_column :packing_lists, :starred
  end
end
