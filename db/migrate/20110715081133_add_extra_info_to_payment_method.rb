class AddExtraInfoToPaymentMethod < ActiveRecord::Migration
   def self.up
    add_column :payment_methods, :check,:boolean, :default => false
    add_index :payment_methods, :check


  end

  def self.down
    remove_column :payment_methods, :check
    remove_column :payment_methods, :check


  end
end
