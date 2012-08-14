class CreateProductUoms < ActiveRecord::Migration
  def self.up
    create_table :product_uoms do |t|
      t.string :name,        :null => false, :limit => 45
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :product_uoms
  end
end
