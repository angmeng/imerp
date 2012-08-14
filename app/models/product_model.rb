class ProductModel < ActiveRecord::Base
  has_many :products
  validates :name, :presence => true, :length => {:maximum => 45},
                   :uniqueness => true
                   
  scope :active, where("disabled = false")
end
