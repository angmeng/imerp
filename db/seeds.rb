# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
unless Setting.first
  s = Setting.new
  s.company_name = "SSH Sdn Bhd"
  s.company_address_one = "address one"
  s.company_address_two = "address two"
  s.company_postcode = "14000"
  s.company_city = "PG"
  s.company_country = "Malaysia"
  s.product_prefix_code = "SSH"
  s.product_last_number = 6000000000
  s.save!
end

unless User.first
  u = User.new
  u.login = "admin"
  u.name = "Admin"
  u.email = "angmeng@gmail.com"
  u.department = Department.create!(:name => "Admin")
  u.password = "123456"
  u.password_confirmation = "123456"
  u.save!
end

unless ProductKind.first
  ProductKind.create!(:name => "Normal")
  ProductKind.create!(:name => "Mixed")
end
