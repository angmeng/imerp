class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :company_name, :limit => 100
      t.string :company_address_one, :limit => 100
      t.string :company_address_two, :limit => 100
      t.string :company_postcode, :limit => 5
      t.string :company_city, :limit => 45
      t.string :company_country, :limit => 45
      t.string :product_prefix_code, :limit => 6
      #t.integer :product_last_number, :default => 0
      t.column :product_last_number, :bigint, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
