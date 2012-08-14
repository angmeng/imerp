class AddPacksToPack < ActiveRecord::Migration
  def self.up
     add_column :packs, :packing,:boolean, :default => true
     add_column :pack_items, :packing,:boolean, :default => true
  end

  def self.down
    remove_column :packs, :packing
    remove_column :pack_items, :packing
  end
end
