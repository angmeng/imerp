class CreateCustomerCreditNoteItems < ActiveRecord::Migration
  def self.up
    create_table :customer_credit_note_items do |t|
      t.integer :customer_credit_note_id, :default => 0
      t.integer :product_id, :default => 0
      t.integer :product_uom_id, :default => 0
      t.integer :quantity, :default => 0
      t.decimal :unit_price, :precision => 12, :scale => 2, :default => 0.00
      t.string :remark
      t.boolean :posted, :default => false


      t.timestamps
    end
    add_index :customer_credit_note_items, :customer_credit_note_id
    add_index :customer_credit_note_items, :product_id
    add_index :customer_credit_note_items, :product_uom_id

  end

  def self.down
    drop_table :customer_credit_note_items
  end
end
