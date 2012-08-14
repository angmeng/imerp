class AddPhoneFaxNumberToSetting < ActiveRecord::Migration
  def self.up
     add_column :settings, :phone_number,:string, :limit => 20
     add_column :settings, :fax_number,:string, :limit => 20

  end

  def self.down
     remove_column :settings, :phone_number,:string, :limit => 20
     remove_column :settings, :fax_number,:string, :limit => 20
  end
end
