class PriceLevel < ActiveRecord::Base
  has_many :product_pricings, :dependent => :destroy
  has_many :customer
  validates :name, :presence => true, :length => {:maximum => 45},
                   :uniqueness => true
                   
  scope :active, where("disabled = false")
  
  after_create :setup
  
  
  
  private
  
  def setup
    setup_pricings
  end
  
  def setup_pricings
    ProductUomItem.all.each do |i|
      product_pricings.create!(:product_uom_item_id => i.id,:product_uom_id => i.product_uom_id,:product_id => i.product_id)
    end
  end
end
