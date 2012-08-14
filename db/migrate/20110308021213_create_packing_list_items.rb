class CreatePackingListItems < ActiveRecord::Migration
  def self.up
    create_table :packing_list_items do |t|
      t.integer :packing_list_id , :null => false
      t.integer :sales_order_item_id , :null => false
      t.integer :quantity , :null => false
      t.integer :product_id , :null => false
      t.decimal :unit_price , :null => false
      t.string :remark
      t.string :product_uom_id , :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :packing_list_items
  end
end
