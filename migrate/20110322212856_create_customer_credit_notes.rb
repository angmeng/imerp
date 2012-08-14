class CreateCustomerCreditNotes < ActiveRecord::Migration
  def self.up
    create_table :customer_credit_notes do |t|
      t.string :cust_credit_note_number, :limit => 20
      t.date :cust_credit_note_date
      t.string :remark
      t.boolean :voided, :default => false
      t.boolean :posted, :default => false
      t.integer :customer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :customer_credit_notes
  end
end
