class StockAdjustmentItem < ActiveRecord::Base
  belongs_to :stock_adjustment
  belongs_to :product
  belongs_to :stock_location
  belongs_to :product_uom
 
end
