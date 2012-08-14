class CreateSuppliers < ActiveRecord::Migration
  def self.up
    create_table :suppliers do |t|
      t.string :code, :limit => 45
      t.string :name, :limit => 100
      t.string :company_number, :limit => 20
      t.string :address
      t.string :city, :limit => 45
      t.string :postcode, :limit => 10
      t.string :email, :limit => 45
      t.string :office_contact, :limit => 20
      t.string :office_contact2, :limit => 20
      t.string :fax_number, :limit => 20
      t.string :contact_person, :limit => 45
      t.string :contact_number, :limit => 20
      t.string :term, :limit => 45
      t.string :remark
      t.boolean :suspend, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :suppliers
  end
end
