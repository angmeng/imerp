class CreatePurchaseRequisitions < ActiveRecord::Migration
  def self.up
    create_table :purchase_requisitions do |t|
      t.date :pr_date
      t.string :pr_number, :limit => 20
      t.string :remark
      t.boolean :void, :default => false
      t.integer :issued_user_id, :default => 0
      t.integer :approved_user_id, :default => 0
      t.integer :status_id, :default => 0
      t.integer :company_id, :default => 1

      t.timestamps
    end
    add_index :purchase_requisitions, :issued_user_id
    add_index :purchase_requisitions, :approved_user_id
    add_index :purchase_requisitions, :status_id
    add_index :purchase_requisitions, :company_id
  end

  def self.down
    drop_table :purchase_requisitions
  end
end
