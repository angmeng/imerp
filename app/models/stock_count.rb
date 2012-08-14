class StockCount < ActiveRecord::Base
  belongs_to :stock_location
  belongs_to :product_uom_item
  
  validates :stock_location_id, :product_uom_id, :product_id,:presence => true
  validates :product_uom_item_id, :uniqueness => {:scope => :stock_location_id}


  before_save :update_location


  private

   def update_location
    self.product_location_id = stock_location.product_rack.product_location_id
    self.product_rack_id =  stock_location.product_rack_id
  end
  
end
