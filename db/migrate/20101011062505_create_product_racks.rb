class CreateProductRacks < ActiveRecord::Migration
  def self.up
    create_table :product_racks do |t|
      t.integer :product_location_id, :null => false
      t.string :name, :limit => 45, :null => false
      t.text :description
      t.boolean :disabled, :default => false

      t.timestamps
    end
    add_index :product_racks, :product_location_id
  end

  def self.down
    drop_table :product_racks
  end
end
