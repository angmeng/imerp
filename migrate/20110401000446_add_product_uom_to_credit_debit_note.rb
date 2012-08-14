class AddProductUomToCreditDebitNote < ActiveRecord::Migration
  def self.up
    add_column :customer_credit_note_items, :stock_location_id, :integer
    add_column :customer_debit_note_items, :stock_location_id, :integer
    add_column :supplier_credit_note_items, :stock_location_id, :integer
    add_column :supplier_debit_note_items, :stock_location_id, :integer

    add_index :customer_credit_note_items, :stock_location_id
    add_index :customer_debit_note_items, :stock_location_id
    add_index :supplier_credit_note_items, :stock_location_id
    add_index :supplier_debit_note_items, :stock_location_id
  end

  def self.down
    remove_column :customer_credit_note_items, :stock_location_id
    remove_column :customer_debit_note_items,:stock_location_id
    remove_column :supplier_credit_note_items, :stock_location_id
    remove_column :supplier_debit_note_items,:stock_location_id

    remove_index  :customer_credit_note_items, :stock_location_id
    remove_index  :customer_debit_note_items, :stock_location_id
    remove_index  :supplier_credit_note_items, :stock_location_id
    remove_index  :supplier_debit_note_items, :stock_location_id
  end
end
