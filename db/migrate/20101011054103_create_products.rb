class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :code, :limit => 45, :null => false
      t.text :full_description
      t.string :short_description, :limit => 45
      t.integer :product_kind_id, :null => false
      t.integer :product_category_id, :default => 0
      t.integer :product_brand_id, :default => 0
      t.integer :product_department_id, :default => 0
      t.integer :product_model_id, :default => 0
      t.boolean :is_stock, :default => true
      t.boolean :is_sales, :default => true
      t.boolean :is_open_item, :default => false
      t.boolean :is_taxable, :default => false
      t.boolean :is_disposal, :default => false
      t.boolean :has_serial_no, :default => false
      t.boolean :allow_discount_below_cost, :default => false
      t.boolean :allow_negative_amount, :default => false
      t.boolean :allow_quantity_discount, :default => false
      t.boolean :allow_free_of_charge, :default => false
      t.boolean :allow_zero_selling_price, :default => false
      t.boolean :allow_zero_purchase_price, :default => false
      t.boolean :allow_sales_discount, :default => false
      t.boolean :allow_return_to_vendor, :default => false
      t.boolean :cost_include_freight_charge, :default => false
      t.boolean :cost_include_insurance, :default => false
 
      t.timestamps
    end
    
    add_index   :products, :product_kind_id
    add_index   :products, :product_category_id
    add_index   :products, :product_brand_id
    add_index   :products, :product_model_id
    add_index   :products, :product_department_id
  end

  def self.down
    drop_table :products
  end
end
