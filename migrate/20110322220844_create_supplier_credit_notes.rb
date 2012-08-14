class CreateSupplierCreditNotes < ActiveRecord::Migration
  def self.up
    create_table :supplier_credit_notes do |t|
      t.string :supplier_credit_note_number, :limit => 20
      t.date :supplier_credit_note_date
      t.string :remark
       t.boolean :voided, :default => false
      t.boolean :posted, :default => false
      t.integer :supplier_id

      t.timestamps
    end
  end

  def self.down
    drop_table :supplier_credit_notes
  end
end
