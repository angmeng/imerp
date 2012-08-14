class CreatePriceLevels < ActiveRecord::Migration
  def self.up
    create_table :price_levels do |t|
      t.string :name, :null => false, :limit => 45
      t.text :description
      t.boolean :disabled

      t.timestamps
    end
  end

  def self.down
    drop_table :price_levels
  end
end
