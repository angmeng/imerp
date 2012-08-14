class SupplierCreditNote < ActiveRecord::Base
  has_many :supplier_credit_note_items
  has_many :product_movements, :as => :movement
  belongs_to :supplier

  validates :supplier_credit_note_date, :presence => true
  before_create :generate_scn_number
   scope :unsettled, where(:settled => false)

  attr_reader :product_tokens
def check_settle
      error_count = 0
        if supplier_credit_note_items.any?
        supplier_credit_note_items.each do |i|
         if i.product_uom_id == 0 or i.quantity == 0 or i.unit_price == 0 or i.stock_location_id == 0
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
  def check_supplier

      error_count = 0
      if supplier_id.nil? or supplier_id == 0
        error_count +=1
      end
      if error_count == 0
        return true
      else
        return false
      end
  end
  def update_item(item)
    error_msg = ""
    item.each do |item_id, content|
      i = supplier_credit_note_items.find(item_id.to_i)
      if content[:product_uom_id].to_i > 0
         if supplier_credit_note_items.where("id != ? and product_id = ? and product_uom_id = ?", item_id, i.product_id, content[:product_uom_id]).first
            error_msg << Product.find(i.product_id.to_i).code + " - " + ProductUom.find(content[:product_uom_id].to_i).name + " - is already exist <br>"
        else
          unless content[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:quantity].blank? or content[:unit_price].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:unit_price].blank?
            i = supplier_credit_note_items.find(item_id.to_i)
            i.quantity = content[:quantity].to_i
            i.product_uom_id = content[:product_uom_id].to_i
            i.stock_location_id = content[:stock_location_id].to_i
            i.unit_price = content[:unit_price].to_f
            i.save!
          end
        end
         else
          unless content[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:quantity].blank? or content[:unit_price].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:unit_price].blank?
            i = supplier_credit_note_items.find(item_id.to_i)
            i.quantity = content[:quantity].to_i
            i.product_uom_id = content[:product_uom_id].to_i
            i.stock_location_id = content[:stock_location_id].to_i
            i.unit_price = content[:unit_price].to_f
            i.save!
          end
        end
      end
      error_msg
  end

 def remove_item(item)
    item.each do |inv_id, content|
      if content[:selected].to_i == 1
        i = supplier_credit_note_items.find(inv_id)
        i.destroy
      end
    end
  end

  def add_autocomplete_item(item)
    item_ids = item[:product_tokens].split(",")
    item_ids.uniq.each do |i|
      found = Product.find(i.to_i) rescue nil
      supplier_credit_note_items.create!(:product_id => i.to_i, :stock_location_id => 0) if found
    end

  end

  def add_item(item)
    error_msg = ""
    item.each do |p_id, content|
      if content[:selected].to_i == 1
        if content[:product_uom_id].to_i > 0
          if supplier_credit_note_items.first(:conditions => ["product_id = ? and product_uom_id = ? ", p_id , content[:product_uom_id].to_i])
           error_msg << Product.find(p_id.to_i).code + " - " + ProductUom.find(content[:product_uom_id].to_i).name + " - is already exist <br>"
          else
            i = supplier_credit_note_items.new
            i.product_id = p_id.to_i
            i.stock_location_id = 0
            unless content[:product_uom_id].blank?
             i.product_uom_id = content[:product_uom_id].to_i
            end
            i.save!
          end
        
      else
          i = supplier_credit_note_items.new
          i.product_id = p_id.to_i
          i.stock_location_id = 0
          unless content[:product_uom_id].blank?
           i.product_uom_id = content[:product_uom_id].to_i
          end
          i.save!
        end
      end
    end
   error_msg
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
        supplier_credit_note_items.each do |d|
          item = ProductMovement.new(:movement_date => Date.today, :movement => self)
          unless d.posted?
            item.product_id = d.product_id
            item.product_uom_id = d.product_uom_id
            item.stock_location_id = d.stock_location_id
            item.cost = d.unit_price
            item.quantity = Engineer.negative(d.quantity)
            item.description = ProductMovement::ADD_SUPPLIER_CN_DESC
            item.save!

            d.posted = true
            d.save!
            uom_item = ProductUomItem.first(:conditions => ["product_id = ? and product_uom_id = ?", d.product_id, d.product_uom_id])
            found = StockCount.first(:conditions => ["stock_location_id = ? and product_uom_item_id = ?", d.stock_location_id, uom_item.id])
            found = StockCount.create!(:stock_location_id => d.stock_location_id, :product_uom_item_id => uom_item.id, :product_id => d.product_id, :product_uom_id => d.product_uom_id) unless found
            found.quantity -= d.quantity
            found.save!
          end
        end
        self.posted = true
        save!
      end
    end
  end
  def remove_item(item)
    item.each do |item_id, content|
      if content[:selected]
        i = supplier_credit_note_items.find(item_id)
        i.destroy
      end
    end
 end

 def removed_scn_item(item)
    item.each do |item_id, content|
      if content[:selected]
       i = supplier_credit_note_items.find(item_id)
        i.destroy
      end
    end
 end




 private
def generate_scn_number
    setting = Setting.first
    setting.supplier_credit_note_last_number += 1
    setting.save!
    self.supplier_credit_note_number = setting.supplier_credit_note_code + setting.supplier_credit_note_last_number.to_s
  end

end
