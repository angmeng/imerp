class CreateSupplierDebitNotes < ActiveRecord::Migration
  def self.up
    create_table :supplier_debit_notes do |t|
      t.string :supplier_debit_note_number, :limit => 20
      t.date :supplier_debit_note_date
      t.string :remark
      t.boolean :voided, :default => false
      t.boolean :posted, :default => false
      t.integer :supplier_id

      t.timestamps
    end
  end

  def self.down
    drop_table :supplier_debit_notes
  end
end
