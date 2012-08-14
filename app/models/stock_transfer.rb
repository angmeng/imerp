class StockTransfer < ActiveRecord::Base
  belongs_to :user
  has_many :stock_transfer_items
  has_many :product_movements, :as => :movement
  
  validates :stock_transfer_date, :presence => true
  before_create :generate_st_number
  attr_reader :product_tokens
   scope :unsettled, where(:settled => false)
   
  def check_settle
      error_count = 0
      if stock_transfer_items.any?
        stock_transfer_items.each do |i|
         if i.product_uom_id == 0 or i.quantity == 0
           error_count += 1
         end
        end
      else
        error_count += 1
      end
      if error_count == 0
        self.settled = true
        save!
        return true
      else
        return false
      end

  end
  
  def add_autocomplete_item(item)
      item_ids = item[:product_tokens].split(",")
      item_ids.uniq.each do |i|
      found = Product.find(i.to_i) rescue nil
        stock_transfer_items.create!(:product_id => i.to_i) if found
        end
  end
   
  def add_item(item)
    item.each do |p_id, content|
      if content[:selected].to_i == 1
          i = stock_transfer_items.new
          unless content[:product_uom_id].blank?
           i.product_uom_id = content[:product_uom_id].to_i
          end
          i.product_id = p_id.to_i
          i.from_stock_location_id = 0
          i.to_stock_location_id = 0
          i.save!
         end
       end
    end

  def update_item(item)
     error_msg = ""
    item.each do |item_id, content|
      i = stock_transfer_items.find(item_id.to_i)
      if content[:product_uom_id].to_i > 0
        if content[:from_stock_location_id].to_i > 0
            if content[:to_stock_location_id].to_i > 0
                if stock_transfer_items.where("id != ? and product_id = ? and product_uom_id = ? and from_stock_location_id = ? and to_stock_location_id = ?", item_id, i.product_id, content[:product_uom_id],content[:from_stock_location_id].to_i,content[:to_stock_location_id].to_i ).first
                  error_msg << Product.find(i.product_id.to_i).code + " - " + ProductUom.find(content[:product_uom_id].to_i).name + " - " + StockLocation.find(content[:from_stock_location_id].to_i).product_rack.name + " - " + StockLocation.find(content[:to_stock_location_id].to_i).product_rack.name + " - is already exist <br>"
                else
                    unless content[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:quantity].blank?
                      i = stock_transfer_items.find(item_id.to_i)
                      i.description = content[:description]
                      i.product_uom_id = content[:product_uom_id].to_i
                      i.from_stock_location_id = content[:from_stock_location_id].to_i
                      i.to_stock_location_id = content[:to_stock_location_id].to_i
                      i.quantity = content[:quantity].to_i
                      i.save!
                    end
                end
            else
                unless content[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:quantity].blank?
                    i = stock_transfer_items.find(item_id.to_i)
                    i.description = content[:description]
                    i.product_uom_id = content[:product_uom_id].to_i
                    i.from_stock_location_id = content[:from_stock_location_id].to_i
                    i.to_stock_location_id = content[:to_stock_location_id].to_i
                    i.quantity = content[:quantity].to_i
                    i.save!
                end
            end
         else
              unless content[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:quantity].blank?
                    i = stock_transfer_items.find(item_id.to_i)
                    i.description = content[:description]
                    i.product_uom_id = content[:product_uom_id].to_i
                    i.from_stock_location_id = content[:from_stock_location_id].to_i
                    i.to_stock_location_id = content[:to_stock_location_id].to_i
                    i.quantity = content[:quantity].to_i
                    i.save!
               end
          end
       else
        unless content[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:quantity].blank?
          i = stock_transfer_items.find(item_id.to_i)
          i.description = content[:description]
          i.product_uom_id = content[:product_uom_id].to_i
          i.from_stock_location_id = content[:from_stock_location_id].to_i
          i.to_stock_location_id = content[:to_stock_location_id].to_i
          i.quantity = content[:quantity].to_i
          i.save!
        end
      end
    end
    error_msg
  end


  def remove_item(item)
    item.each do |inv_id, content|
      if content[:selected].to_i == 1
        i = stock_transfer_items.find(inv_id)
        i.destroy
      end
    end
 end

 def status
    if settled?
        "<em style='color:green'>Completed</em>"
      else
         "<em style='color:blue'>Processing</em>"
      end
end

def quantity_post_status
if posted?
         "<em style='color:purple'>Posted Quantity</em>"
      else
           "<em style='color:orange'>Unpost Quantity</em>"
      end
 end
 
 def void_status
    if voided?
        "<em style='color:red'>Voided</em>"
     else
        "<em style='color:brown'>Unvoided</em>"
    end
  end

  def post_quantity
    if posted?
      return false
    else
      transaction do
        stock_transfer_items.each do |d| 
          unless d.posted?
            item = ProductMovement.new(:movement_date => Date.today, :movement => self)
            item.product_id = d.product_id
            item.product_uom_id = d.product_uom_id
            item.stock_location_id = d.from_stock_location_id
              found = ProductUomItem.first(:conditions => ["product_id = ? and product_uom_id = ?", d.product_id, d.product_uom_id])
            item.cost = found.current_cost
            item.quantity =  Engineer.negative(d.quantity)
            item.description = ProductMovement::ADD_TRANSFER
            item.save!
            d.posted = true
            d.save!
            uom_item = ProductUomItem.first(:conditions => ["product_id = ? and product_uom_id = ?", d.product_id, d.product_uom_id])
            found = StockCount.first(:conditions => ["stock_location_id = ?  and product_id = ? and product_uom_id = ?", d.from_stock_location_id,d.product_id, d.product_uom_id])
            found = StockCount.create!(:stock_location_id => d.from_stock_location_id, :product_uom_item_id => uom_item.id, :product_uom_id => d.product_uom_id,:product_id => d.product_id) unless found
            found.quantity -= d.quantity
            found.save!

            item = ProductMovement.new(:movement_date => Date.today, :movement => self)
            item.product_id = d.product_id
            item.product_uom_id = d.product_uom_id
            item.stock_location_id = d.to_stock_location_id
            item.quantity = d.quantity
            item.description = ProductMovement::ADD_TRANSFER
            item.save
            d.posted = true
            d.save!
            uom_item = ProductUomItem.first(:conditions => ["product_id = ? and product_uom_id = ?", d.product_id, d.product_uom_id])
            found = StockCount.first(:conditions => ["stock_location_id = ?  and product_id = ? and product_uom_id = ?", d.to_stock_location_id,d.product_id, d.product_uom_id])
            found = StockCount.create!(:stock_location_id => d.to_stock_location_id, :product_uom_item_id => uom_item.id, :product_uom_id => d.product_uom_id,:product_id => d.product_id) unless found
            found.quantity += d.quantity
            found.save!



          end
        end
        self.posted = true
        save!
      end
    end
  end

 private
def generate_st_number
    setting = Setting.first
    setting.stock_transfer_last_number += 1
    setting.save!
    self.stock_transfer_number = setting.stock_transfer_code + setting.stock_transfer_last_number.to_s
  end
end
