class Department < ActiveRecord::Base
  has_many :users
  
  validates :name, :presence => true, :length => {:maximum => 45},
                   :uniqueness => true
end
