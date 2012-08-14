class GoodsReceiveNote < ActiveRecord::Base
  has_many :goods_receive_note_items
  belongs_to :supplier
  belongs_to :purchase_order
  has_many :product_movements, :as => :movement

  before_create :setup
  validates :purchase_order_id, :do_number, :presence => true
  

  #delegate :code, :name, :address, :office_phone, :fax_number, :contact_person, :contact_number, :active, :remark, :to => :supplier, :prefix => true
  scope :unsettled, where(:settled => false)

 
  def total_amount
    total = 0.0
    goods_receive_note_items.each do |c|
      total += c.total_amount
    end
    total
  end
  
  def check_quantity
    goods_receive_note_items.each do |c|
    PurchaseOrderItem.first(:conditions => ["id = ? and quantity = ?", c.purchase_order_item_id, c.delivered_quantity])
    end

  end


  def status
    if settled?
        "<em style='color:green'>Completed</em>"
      else
        "<em style='color:blue'>Processing</em>"
      end
  end

  def void_status
    if voided?
        "<em style='color:red'>Voided</em>"
     else
        "<em style='color:brown'>Unvoided</em>"
    end
  end

  def verify_settle
    checked = true
    if goods_receive_note_items.any?
     goods_receive_note_items.each do |i|
      checked = false unless i.full_deliver? 
      checked = false unless i.delivered_quantity > 0
      checked = false unless i.unit_price > 0.00
      checked = false unless i.stock_location_id > 0
     
      end
    else
      checked = false
    end
    if checked
      post_quantity  
    end
    checked
  end

def verify_destroy
    if posted?
     pass = false
     msg = "GRN is already posted, you cannot void"
    else
      self.voided = true
      goods_receive_note_items.destroy_all
      if save
        pass = true
        msg = "GRN successfully voided"
      else
        pass = false
        msg = "GRN cannot be save"
      end
    end
    return pass, msg
  end

  def update_items(item)
    error_msg=""
    balance =
    item.each do |item_id, content|
     i = goods_receive_note_items.find(item_id.to_i)
     balance = i.quantity - i.purchase_order_item.collected_quantity
     if content[:delivered_quantity].to_i > balance + i.delivered_quantity
         error_msg << "Deliver quantity exceed"
     else
        i.unit_price = content[:unit_price].to_f rescue i.unit_price
        i.stock_location_id = content[:stock_location_id].to_i
        i.remark = content[:remark]

        i.delivered_quantity = content[:delivered_quantity].to_i unless content[:delivered_quantity].blank?
        i.save!
    end
  end
  error_msg
  end

  def import_items(item)
     total = 0
   total_up = 0
    item.each do |item_id, content|
      if content[:selected].to_i == 1
        po_item = PurchaseOrderItem.find(item_id.to_i)
        total = po_item.collected_quantity
        total_up = po_item.quantity - total

        g = goods_receive_note_items.new
        g.product_id = po_item.product_id
        g.purchase_order_item_id = po_item.id
        g.product_uom_id = po_item.product_uom_id
        g.quantity = po_item.quantity
        g.delivered_quantity = total_up
        g.unit_price = po_item.unit_price
        g.save!
      end unless goods_receive_note_items.first(:conditions => ["purchase_order_item_id = ?", item_id.to_i])
    end
  end

  def post_quantity
    if posted?
      return false
    else
      transaction do
        goods_receive_note_items.each do |d|
          item = ProductMovement.new(:movement_date => Date.today, :movement => self)
          unless d.posted?
            item.product_id = d.product_id
            item.product_uom_id = d.product_uom_id
            item.stock_location_id = d.stock_location_id
            item.quantity = d.delivered_quantity
            item.cost = d.unit_price
            item.description = ProductMovement::ADD_GRN_DESC
            item.save!

            d.posted = true
            d.save!
            uom_item = ProductUomItem.first(:conditions => ["product_id = ? and product_uom_id = ?", d.product_id, d.product_uom_id])
            found = StockCount.first(:conditions => ["stock_location_id = ? and product_uom_item_id = ?", d.stock_location_id, uom_item.id])
            found = StockCount.create!(:stock_location_id => d.stock_location_id, :product_uom_item_id => uom_item.id, :product_uom_id => uom_item.product_uom_id, :product_id => uom_item.product_id) unless found
            found.quantity += d.delivered_quantity
            found.save!

            movement_item = ProductVirtualMovement.where("product_id = ? and product_uom_id = ? and virtual_movement_type = ? and virtual_movement_id = ?", d.product_id, d.product_uom_id, "PurchaseOrder", purchase_order_id).first
            if movement_item
               check = movement_item.quantity - item.quantity
              if check == 0
                movement_item.destroy
              else
                movement_item.quantity -= item.quantity
                movement_item.save!
              end

            end
          end
        end
        self.posted = true
        self.settled = true
        save!
        check_purchase_order_status
      end
    end
  end
  def remove_item(item)
    item.each do |item_id, content|
      if content[:selected]
        i = goods_receive_note_items.find(item_id)
        i.destroy
      end
    end
 end

  private

  def check_purchase_order_status
    check = true
    p = purchase_order
    p.purchase_order_items.each do |i|
      check = false unless i.full_delivery?
    end
    if check
      p.imported = true
      p.save!
    end
  end

  def setup
    generate_number
    assign_supplier
  end

  def generate_number
    setting = Setting.first
    setting.grn_last_number += 1
    setting.save!
    self.grn_number = setting.grn_code + setting.grn_last_number.to_s
  end

  def assign_supplier
    self.supplier_id = purchase_order.supplier_id
  end

end
