class AddVoidToGoodsReceiveNotes < ActiveRecord::Migration
  def self.up
    add_column :goods_receive_notes, :void, :boolean, :default => false
    add_index :goods_receive_notes, :void
  end

  def self.down
    remove_index :goods_receive_notes, :void
    remove_column :goods_receive_notes, :void
  end
end
