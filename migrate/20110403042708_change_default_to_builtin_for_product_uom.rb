class ChangeDefaultToBuiltinForProductUom < ActiveRecord::Migration
  def self.up
    rename_column(:product_uoms, :default, :builtin)
  end

  def self.down
  end
end
