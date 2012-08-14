class StockDisposalItem < ActiveRecord::Base
  belongs_to :stock_disposal
  belongs_to :product
  belongs_to :stock_location
  belongs_to :product_uom

  
end
