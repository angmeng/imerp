class MixedProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :product_uom
  belongs_to :parent, :class_name => "Product"
  
  validates :product_id, :parent_id, :quantity, :presence => true
  validates :product_id, :uniqueness => {:scope => :parent_id}

  scope :non_mixed, where("mixed = false")
  scope :mixed, where("mixed = true")

end
