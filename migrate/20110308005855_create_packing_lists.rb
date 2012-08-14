class CreatePackingLists < ActiveRecord::Migration
  def self.up
    create_table :packing_lists do |t|
      t.date :packing_list_date
      t.string :packing_list_number, :limit => 20
      t.string :term
      t.string :remark
      t.boolean :voided, :default => false
      t.boolean :settled, :default => false
      t.boolean :imported, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :packing_lists
  end
end
