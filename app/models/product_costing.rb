class ProductCosting < ActiveRecord::Base
  belongs_to :product
  belongs_to :product_uom

  
end
