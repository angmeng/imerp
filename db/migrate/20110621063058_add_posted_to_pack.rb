class AddPostedToPack < ActiveRecord::Migration
  def self.up
    add_column :packs, :posted,:boolean, :default => false
    add_column :pack_items, :posted,:boolean, :default => false
  end

  def self.down
    remove_column :packs, :posted
    remove_column :pack_items, :posted
  end
end
