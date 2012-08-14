class CreateGoodsReceiveNotes < ActiveRecord::Migration
  def self.up
    create_table :goods_receive_notes do |t|
      t.date :grn_date
      t.string :grn_number, :limit => 20
      t.string :do_number, :limit => 20
      t.string :invoice_number, :limit => 20
      t.string :serial_number, :limit => 20
      t.string :remark
      t.integer :supplier_id, :default => 0
      t.integer :purchase_order_id, :default => 0
      t.boolean :voided, :default => false
      t.boolean :settled, :default => false

      t.timestamps
    end
    add_index :goods_receive_notes, :supplier_id
    add_index :goods_receive_notes, :purchase_order_id
    add_index :goods_receive_notes, :voided
    add_index :goods_receive_notes, :settled
  end

  def self.down
    drop_table :goods_receive_notes
  end
end
