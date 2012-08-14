class Pack < ActiveRecord::Base
  has_many :pack_items
  has_many :product_movements, :as => :movement
  belongs_to :user

  before_create :generate_pack_number
  attr_reader :product_tokens

def status
  if posted?
         "<em style='color:purple'>Posted Quantity</em>"
      else
           "<em style='color:orange'>Unpost Quantity</em>"
      end
 end
def add_autocomplete_item(item)
     item_ids = item[:product_tokens].split(",")
      item_ids.uniq.each do |i|
        found = Product.find(i.to_i) rescue nil
           pack_items.create!(:product_id => i.to_i,:stock_location_id => 0,:quantity => 0) if found
        end
  end


 def add_item(item)
   error_msg = ""
    item.each do |p_id, content|
      if content[:selected].to_i == 1
        if content[:product_uom_id].to_i > 0
           #if pack_items.where("product_id = ? and product_uom_id = ? and stock_location_id = ?", p_id , content[:product_uom_id].to_i, content[:stock_location_id].to_i).first
           if pack_items.first(:conditions => ["product_id = ? and product_uom_id = ? and stock_location_id = ?", p_id , content[:product_uom_id].to_i , content[:stock_location_id].to_i])
               error_msg << Product.find(p_id.to_i).code + " - " + ProductUom.find(content[:product_uom_id].to_i).name + " - " + StockLocation.find(content[:stock_location_id].to_i).product_rack.name + " - is already exist <br>"
            else
            i = pack_items.new
            i.product_uom_id = content[:product_uom_id].to_i
            i.product_id = p_id.to_i
            i.stock_location_id = content[:stock_location_id].to_i
            i.quantity = 0
            uom_item = ProductUomItem.first(:conditions => ["product_id = ? and product_uom_id = ?", p_id, content[:product_uom_id].to_i])
            i.cost = uom_item.current_cost
            i.save!
           end
        else
          error_msg << "Please Select uom of product to add item"
       end
      end
    end
    error_msg
    end

 def update_item(item)
    error_msg = ""
    item.each do |item_id, content|
       i = pack_items.find(item_id.to_i)
        if content[:stock_location_id].to_i > 0
           if(content[:product_uom_id].to_i > 0)
             if pack_items.where("id != ? and product_id = ? and product_uom_id = ? and stock_location_id = ?", item_id, i.product_id, content[:product_uom_id],content[:stock_location_id].to_i ).first
                error_msg << Product.find(i.product_id.to_i).code + " - " + ProductUom.find(content[:product_uom_id].to_i).name + " - " + StockLocation.find(content[:stock_location_id].to_i).product_rack.name + " - is already exist <br>"
             else
                unless content[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:quantity].blank?
                  i = pack_items.find(item_id.to_i)
                  i.product_uom_id = content[:product_uom_id].to_i
                  i.stock_location_id = content[:stock_location_id].to_i
                  i.quantity = content[:quantity].to_i
                 
                  i.save!
                end
            end
          else
            unless content[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:quantity].blank?
              i = pack_items.find(item_id.to_i)
              i.product_uom_id = content[:product_uom_id].to_i
              i.stock_location_id = content[:stock_location_id].to_i
              i.quantity = content[:quantity].to_i
             
              i.save!
            end
          end
         else
          unless content[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:quantity].blank?
            i = pack_items.find(item_id.to_i)
            i.product_uom_id = content[:product_uom_id].to_i
            i.stock_location_id = content[:stock_location_id].to_i
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
        i = pack_items.find(inv_id)
        i.destroy
      end
    end
 end

def post_quantity
    if posted?
      return false
    else
      qty = 0
      transaction do
        pack_items.each do |d|
         d.pack_item_subitems.each do |i|
            qty = d.quantity * i.quantity
              item = ProductMovement.new(:movement_date => Date.today, :movement => self)

                item.product_id = i.product_id
                item.product_uom_id = i.product_uom_id
                item.stock_location_id = i.stock_location_id
                item.quantity = i.quantity
                item.cost = 0
                if packing == true
                  item.description = ProductMovement::ADD_MIXED_PACK
                else
                  item.description = ProductMovement::ADD_MIXED_UNPACK
                end
                item.save!

                  uom_item = ProductUomItem.first(:conditions => ["product_id = ? and product_uom_id = ?", i.product_id, i.product_uom_id])
                  found = StockCount.first(:conditions => ["stock_location_id = ? and product_uom_item_id = ?", i.stock_location_id, uom_item.id])
                  found = StockCount.create!(:stock_location_id => i.stock_location_id, :product_uom_item_id => uom_item.id, :product_id => i.product_id, :product_uom_id => i.product_uom_id) unless found
                   if packing == true
                    found.quantity -= (d.quantity * i.quantity)
                   else
                     found.quantity += (d.quantity * i.quantity)
                   end
                  found.save!
               end
          
          unless d.posted?
            item = ProductMovement.new(:movement_date => Date.today, :movement => self)
            item.product_id = d.product_id
            item.product_uom_id = d.product_uom_id
            item.stock_location_id = d.stock_location_id
            item.quantity = d.quantity
            found = ProductUomItem.first(:conditions => ["product_id = ? and product_uom_id = ?", d.product_id, d.product_uom_id])
            item.cost = d.cost
            if packing == true
                item.description = ProductMovement::ADD_PACK
            else
                item.description = ProductMovement::ADD_UNPACK
            end
            item.save!

            d.posted = true
            d.save!
            uom_item = ProductUomItem.first(:conditions => ["product_id = ? and product_uom_id = ?", d.product_id, d.product_uom_id])
            found = StockCount.first(:conditions => ["stock_location_id = ?  and product_id = ? and product_uom_id = ?", d.stock_location_id,d.product_id, d.product_uom_id])
            found = StockCount.create!(:stock_location_id => d.stock_location_id, :product_uom_item_id => uom_item.id, :product_uom_id => d.product_uom_id,:product_id => d.product_id) unless found
            if packing == true  
              found.quantity += d.quantity
            else
              found.quantity -= qty
            end
            found.save!
          end
          end
        end
        self.posted = true
        save!
      end
    end


def check_settle
      error_count = 0
      if pack_items.any?
      pack_items.each do |i|
           if i.product_uom_id == 0 or i.quantity == 0 or i.stock_location_id == 0
             error_count += 1
           end
         end
      else
        error_count += 1
      end
      if error_count == 0

        return true
      else
        return false
      end

end

def check_subitem
      error_count = 0
      pack_items.each do |d|
         d.pack_item_subitems.each do |i|
           if  i.stock_location_id == 0
             error_count += 1
           end
         end
      end
     
      if error_count == 0
         return true
      else
        return false
      end

end

 



  private

def generate_pack_number
    setting = Setting.first
    setting.pack_last_number += 1
    setting.save!
    self.pack_number = setting.pack_code + setting.pack_last_number.to_s
end
end
