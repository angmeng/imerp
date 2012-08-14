class AddSattledToCreditDebitNote < ActiveRecord::Migration
def self.up
    add_column :customer_credit_notes, :settled, :boolean, :default => false
    add_column :customer_debit_notes, :settled, :boolean, :default => false
    add_column :supplier_credit_notes, :settled, :boolean, :default => false
    add_column :supplier_debit_notes, :settled, :boolean, :default => false

    add_index :customer_credit_notes, :settled
    add_index :customer_debit_notes, :settled
    add_index :supplier_credit_notes, :settled
    add_index :supplier_debit_notes, :settled
  end

  def self.down
    remove_index :customer_credit_notes, :settled
    remove_index :customer_debit_notes, :settled
    remove_index :supplier_credit_notes, :settled
    remove_index :supplier_debit_notes, :settled
    remove_column :customer_credit_notes, :settled
    remove_column :customer_debit_notes, :settled
    remove_column :supplier_credit_notes, :settled
    remove_column :supplier_debit_notes, :settled

  end
end
