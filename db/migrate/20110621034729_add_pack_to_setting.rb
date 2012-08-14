class AddPackToSetting < ActiveRecord::Migration
 def self.up
    add_column :settings, :pack_code, :string, :default => "PM"
    add_column :settings, :pack_last_number, :integer, :default => 10000
  end

  def self.down
    remove_column :settings, :pack_code
    remove_column :settings, :pack_last_number
  end
end
