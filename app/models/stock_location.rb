class StockLocation < ActiveRecord::Base
  belongs_to :product
  belongs_to :product_rack
  has_many :stock_counts, :dependent => :destroy
  has_many :product_uom_items, :through => :stock_counts
  has_many :stock_adjustment_items
  has_many :from_stock_transfer_items, :class_name => "StockTransferItem", :foreign_key => "from_stock_location_id"
  has_many :to_stock_transfer_items, :class_name => "StockTransferItem", :foreign_key => "to_stock_location_id"
  has_many :supplier_credit_note_items
  has_many :supplier_debit_note_items
  has_many :customer_credit_note_items
  has_many :customer_debit_note_items
  has_many :delivery_order_items
  has_many :stock_disposal_items
  has_many :pack_items
  has_many :pack_item_subitems
  
  validates :product_id, :product_rack_id, :presence => true
  validates :product_rack_id, :uniqueness => {:scope => :product_id}
  
  after_create :setup
  before_save  :update_product_location

  def fullname
    location = product_rack.product_location
    location.name + "-" + product_rack.name
  end

  def add_location(item)
   item.each do |p_id, content|
      if content[:selected].to_i == 1
        i = stock_location.new
     i.product_rack_id = p_id.to_i
       i.save!
      end
    end
  end

  def remove_product(item)
    item.each do |item_id, content|
      if content[:selected]
        i = stock_location.find(item_id)
        i.destroy
      end
    end
 end
 
  
  private
  
  def setup
    setup_stock_counts
  end
  
  def setup_stock_counts
    product.product_uom_items.all.each do |u|
      stock_counts.create!(:product_uom_item_id => u.id, :product_uom_id => u.product_uom_id, :product_id => u.product_id)
    end
    
  end

  def update_product_location
    self.product_location_id = product_rack.product_location_id
  end
  
end
