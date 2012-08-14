class CreateCustomerDebitNotes < ActiveRecord::Migration
  def self.up
    create_table :customer_debit_notes do |t|
      t.string :cust_debit_note_number, :limit => 20
      t.date :cust_debit_note_date
      t.string :remark
      t.boolean :voided, :default => false
      t.boolean :posted, :default => false
      t.integer :customer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :customer_debit_notes
  end
end
