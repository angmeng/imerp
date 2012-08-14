class City < ActiveRecord::Base
  has_many :customers
  has_many :suppliers
  has_many :transports
  has_many :salesman

end
