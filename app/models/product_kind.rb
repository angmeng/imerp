class ProductKind < ActiveRecord::Base
  has_many :products
  validates :name, :presence => true, :length => {:maximum => 45},
                   :uniqueness => true
                   
  scope :active, where("disabled = false")
  
  NORMAL = 1
  MIXED = 2
  
  def verify_destroy
    if [NORMAL, MIXED].include?(id.to_i)
      return false
    else
      destroy
      return true
    end
  end
  
end
