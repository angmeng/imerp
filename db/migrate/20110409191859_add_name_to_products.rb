class AddNameToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :name, :string, :limit => 45
    Product.reset_column_information
    Product.all.each do |p|
      p.name = p.code
      p.save!
    end
  end

  def self.down
    remove_column :products, :name
  end
end
