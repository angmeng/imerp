class CreateProductModels < ActiveRecord::Migration
  def self.up
    create_table :product_models do |t|
      t.string :name, :limit => 45, :null => false
      t.text :description
      t.boolean :disabled, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :product_models
  end
end
