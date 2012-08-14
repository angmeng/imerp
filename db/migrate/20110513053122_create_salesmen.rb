class CreateSalesmen < ActiveRecord::Migration
  def self.up
    create_table :salesmen do |t|
      t.string :code, :limit => 45
      t.string :name, :limit => 45
      t.string :company, :limit => 20
      t.string :address, :limit => 20
      t.string :city, :limit => 45
      t.string :postcode, :limit => 20
      t.string :email, :limit => 45
      t.string :office_contact, :limit => 20
      t.string :office_contact2, :limit => 20
      t.string :fax_number, :limit => 20
      t.string :contact_person, :limit => 45
      t.string :contact_number, :limit => 20
      t.string :term, :limit => 45
      t.string :remark

      t.timestamps
    end
  end

  def self.down
    drop_table :salesmen
  end
end
