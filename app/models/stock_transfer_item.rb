class StockTransferItem < ActiveRecord::Base
   belongs_to :stock_transfer
   belongs_to :product
   belongs_to :from_stock_location, :class_name => "StockLocation"
   belongs_to :to_stock_location, :class_name => "StockLocation"
   belongs_to :product_uom

end
