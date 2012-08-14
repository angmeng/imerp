class PackItemSubitem < ActiveRecord::Base
  belongs_to :pack_item
  belongs_to :product
  belongs_to :product_uom
  belongs_to :stock_location

 
end
