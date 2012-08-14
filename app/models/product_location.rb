class ProductLocation < ActiveRecord::Base
  has_many :product_racks, :dependent => :destroy
  has_many :products, :through => :product_racks
  validates :name, :presence => true, :length => {:maximum => 45},
                   :uniqueness => true
                   
  scope :active, where("disabled = false")
end
