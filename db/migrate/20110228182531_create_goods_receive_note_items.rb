class CreateGoodsReceiveNoteItems < ActiveRecord::Migration
  def self.up
    create_table :goods_receive_note_items do |t|
      t.integer :goods_receive_note_id, :default => 0
      t.integer :product_id, :default => 0
      t.integer :product_uom_id, :default => 0
      t.integer :quantity, :default => 0
      t.decimal :unit_price, :precision => 12, :scale => 2, :default => 0.00
      t.integer :purchase_order_item_id, :default => 0
      t.integer :delivered_quantity, :default => 0
      t.string :remark
      t.integer :stock_location_id, :default => 0
      t.boolean :settled, :default => false

      t.timestamps
    end
    add_index :goods_receive_note_items, :goods_receive_note_id
    add_index :goods_receive_note_items, :product_id
    add_index :goods_receive_note_items, :product_uom_id
    add_index :goods_receive_note_items, :purchase_order_item_id
    add_index :goods_receive_note_items, :stock_location_id
    add_index :goods_receive_note_items, :settled

  end

  def self.down
    drop_table :goods_receive_note_items
  end
end
