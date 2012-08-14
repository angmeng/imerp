class ProductPricing < ActiveRecord::Base
  belongs_to :product_uom_item
  belongs_to :price_level
  
  validates :product_uom_item_id, :price_level_id, :presence => true
  validates :price_level_id, :uniqueness => {:scope => [:product_uom_id, :product_id]}
  validates :selling_price, :presence => true, :numericality => true, :inclusion => { :in => (0..99999999)}
end
