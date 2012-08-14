class AddDisabledToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :disabled, :boolean, :default => false
    add_column :products, :deleted, :boolean, :default => false
  end

  def self.down
    remove_column :products, :disabled
    remove_column :products, :deleted
  end
end

