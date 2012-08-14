class AddBuiltInToPriceLevels < ActiveRecord::Migration
  def self.up
    add_column :price_levels, :built_in, :boolean, :default => false
  end

  def self.down
    remove_column :price_levels, :built_in
  end
end
