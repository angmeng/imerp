class AddUseLimitAndCreditLimitToCustomer < ActiveRecord::Migration
def self.up
    add_column :customers, :use_limit,:decimal
    add_index :customers, :use_limit
    add_column :customers, :credit_limit,:decimal
    add_index :customers, :credit_limit
  end

  def self.down
    remove_column :customers, :use_limit,:decimal
    remove_index :customers, :use_limit
    remove_column :customers, :credit_limit,:decimal
    remove_index :customers, :credit_limit

  end
end
