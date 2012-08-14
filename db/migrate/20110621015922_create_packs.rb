class CreatePacks < ActiveRecord::Migration
  def self.up
    create_table :packs do |t|
      t.date :pack_date
      t.string :pack_number, :limit => 20
      t.integer :user_id
      t.string :remark

      t.timestamps
    end
    add_index :packs, :user_id
  end

  def self.down
    drop_table :packs
  end
end
