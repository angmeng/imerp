class ProductUomItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :product_uom
  has_many :product_pricings, :dependent => :destroy
  has_many :stock_counts, :dependent => :destroy
  has_many :stock_locations, :through => :stock_counts
  
  validates :product_id, :product_uom_id, :presence => true
  validates :conversion, :presence => true, :numericality => true, :inclusion => { :in => (0..99999999)}
                         #:uniqueness => {:scope => :product_id}
  
  after_create :setup
  attr_accessor :virtual_packing_quantity, :virtual_order_quantity, :on_hand_quantity



  def current_cost
    total_amount = 0.00
    total_qty = 0

    ProductCosting.where("product_id = ? and product_uom_id = ?", product_id, product_uom_id).all.each do |c|
      total_amount += c.quantity * c.cost
      total_qty += c.quantity
    end
    if total_qty > 0
      return total_amount / total_qty
    else
      return fixed_cost #product_cost_price existing data
    end

  end

  def decrease(qty)
    if qty > 0
      qty_need_to_decrease = qty
    elsif qty < 0
      qty_need_to_decrease = Engineer.negative(qty)
    end

    ProductCosting.where("product_id = ? and product_uom_id = ?", product_id, product_uom_id).all.each do |p|
      if qty_need_to_decrease > 0
        if p.quantity == qty_need_to_decrease
          p.destroy
          qty_need_to_decrease -= qty_need_to_decrease
        elsif p.quantity > qty_need_to_decrease
          p.quantity -= qty_need_to_decrease
          p.save!
          qty_need_to_decrease -= qty_need_to_decrease
        elsif p.quantity < qty_need_to_decrease
          p.destroy
          qty_need_to_decrease -= p.quantity
        end
      end
    end
  end

  def increase(qty)
    ProductCosting.create!(:cost => current_cost, :quantity => qty, :product_id => product_id, :product_uom_id => product_uom_id)
  end


  def balance
    on_hand_quantity + virtual_order_quantity + virtual_packing_quantity
  end

  def collect_stocks
    StockCount.where("product_id = ? and product_uom_id = ?  ", product_id, product_uom_id).all
  end

  private
  
  def setup
    setup_pricings
    #setup_opening_balances
  end
  
  def setup_pricings
    PriceLevel.all.each do |p|
      product_pricings.create!(:price_level_id => p.id,:product_uom_id => product_uom_id,:product_id => product_id )
    end
  end
  
#  def setup_opening_balances
#    ProductRack.all.each do |p|
#      p.stock_locations.all.each do |l|
#        stock_counts.create!(:stock_location_id => l.id, :product_id => product_id, :product_uom_id => product_uom_id)
#      end
#    end
#  end
end
