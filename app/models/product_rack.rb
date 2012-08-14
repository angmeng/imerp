class ProductRack < ActiveRecord::Base
  belongs_to :product_location
  has_many :stock_locations, :dependent => :destroy
  has_many :products, :through => :stock_locations

  after_create :setup
  validates :name, :presence => true, :length => {:maximum => 45},
                   :uniqueness => {:scope => :product_location_id}
  attr_reader :product_tokens
                   
  scope :active, where("disabled = false")

  def verify_destroy
    #if StockCount.where("stock_location_id IN (?)", stock_location_ids).first
    #  return false
    #else
      destroy
    #  return true
    #end
  end

  def add_item(item)
    error_msg = ""
    item.each do |p_id, content|
      if content[:selected].to_i == 1
        #unless stock_locations.first(:conditions => ["product_id = ? and product_uom_id = ?", p_id.to_i, content[:product_uom_id].to_i])
        if stock_locations.first(:conditions => ["product_id =?", p_id])
           error_msg << Product.find(p_id.to_i).code + " already exist <br>"
         else
          i = stock_locations.new
          i.product_id = p_id.to_i
          #i.product_uom_id = content[:product_uom_id]
          i.save!
        end
      end
    end
 error_msg
  end

  def add_autocomplete_item(item)
     error_msg = ""
    item_ids = item[:product_tokens].split(",")
    item_ids.uniq.each do |i|
      found = Product.find(i.to_i) rescue nil
       if stock_locations.first(:conditions => ["product_id =?", found.id])
           error_msg << found.code + " already exist <br>"
        else
          stock_locations.create!(:product_id => i.to_i) if found
      end
  end
  error_msg
 end

  def remove_item(item)
    item.each do |item_id, content|
      if content[:selected]
        i = stock_locations.first(:conditions => ["product_id = ?", item_id])
        i.destroy if i
      end
    end
 end
  
  
  private
  
  def setup
    #create_default_product
  end
  
  def create_default_product
    Product.all.each do |p|
       i = stock_locations.new
       i.product_id = p.id
       i.save!
    end
    
  end


 
end
