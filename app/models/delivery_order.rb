 class DeliveryOrder < ActiveRecord::Base
  belongs_to :customer
  belongs_to :transport
  belongs_to :salesman
  belongs_to :packing_list
  belongs_to :transport
  has_many :delivery_order_items
  has_many :invoice_items
  has_many :product_movements, :as => :movement


  before_create :setup
  before_save    :update_name
  validates :packing_list_id, :purchase_order_number, :presence => true
  validates :transport_id, :exclusion => {:in => [0]}
 
 

  #delegate :code, :name, :address, :office_phone, :fax_number, :contact_person, :contact_number, :active, :remark, :to => :supplier, :prefix => true
  scope :unsettled, where(:settled => false)
  scope(:unimported, where(:voided => false, :settled => false, :imported => false))
  scope :settled, where(:settled => true)

   

  def total_amount
    total = 0.0
    delivery_order_items.each do |c|
      total += c.total_amount
      
     end
    total
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

  def post_quantity
    if posted?
      return false
    else
      transaction do
        delivery_order_items.each do |d|
          item = ProductMovement.new(:movement_date => Date.today, :movement => self)
          unless d.posted?
            item.product_id = d.product_id
            item.product_uom_id = d.product_uom_id
            item.stock_location_id = d.stock_location_id
            item.cost = d.unit_price
            item.quantity =  Engineer.negative(d.quantity)
            item.description = ProductMovement::ADD_DO_DESC
            item.save!

            d.posted = true
            d.save!
            uom_item = ProductUomItem.first(:conditions => ["product_id = ? and product_uom_id = ?", d.product_id, d.product_uom_id])
            found = StockCount.first(:conditions => ["stock_location_id = ? and product_uom_item_id = ?", d.stock_location_id, uom_item.id])
            found = StockCount.create!(:stock_location_id => d.stock_location_id, :product_uom_item_id => uom_item.id, :product_uom_id => uom_item.product_uom_id, :product_id => uom_item.product_id) unless found
            found.quantity -= d.delivered_quantity
            found.save!

            movement_item = ProductVirtualMovement.where("product_id = ? and product_uom_id = ? and virtual_movement_type = ? and virtual_movement_id = ?", d.product_id, d.product_uom_id, "PackingList", packing_list_id).first
            if movement_item
              check = movement_item.quantity + item.quantity
              if check == 0
                movement_item.destroy
              else
                movement_item.quantity += item.quantity
                movement_item.save!
              end
              
            end
          end
        end
        self.posted = true
        self.settled = true
        save!
        check_packing_list_status
      end
    end
  end

  def verify_settle
    checked = true
    if delivery_order_items.any?
      delivery_order_items.each do |i|
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

  def check_settle
      error_count = 0
      delivery_order_items.each do |i|
       if  i.delivered_quantity == 0 or i.unit_price == 0 or i.stock_location_id == 0 
         error_count += 1
       end
      end
      if error_count == 0
        return true
      else
        return false
      end
  end

  def verify_destroy
    if posted?
     pass = false
     msg = "Delivery Order is already posted, you cannot void"
    else
      self.voided = true
      delivery_order_items.destroy_all
      if save
        pass = true
        msg = "Delivery order successfully voided"
      else
        pass = false
        msg = "Delivery order cannot be save"
      end
    end
    return pass, msg
  end
  
  def update_items(item, transporter_id)
    error_msg = ""
    balance =
    self.transport_id = transporter_id
    save!
    item.each do |item_id, content|
      i = delivery_order_items.find(item_id)
      balance = i.quantity - i.packing_list_item.collected_quantity
     if content[:delivered_quantity].to_i > balance + i.delivered_quantity
        error_msg << "delivery quantity exceed"
      else
        i.unit_price = content[:unit_price].to_f unless content[:unit_price].blank?
        i.remark =  content[:remark]
        i.stock_location_id = content[:stock_location_id].to_i
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
        po_item = PackingListItem.find(item_id.to_i)
        total = po_item.collected_quantity
        total_up = po_item.quantity - total

        g = delivery_order_items.new
        g.product_id = po_item.product_id
        g.packing_list_item_id = po_item.id
        g.product_uom_id = po_item.product_uom_id
        g.quantity = po_item.quantity
        g.delivered_quantity = total_up
        g.unit_price = po_item.unit_price
        g.discounts = po_item.discounts
       
        g.save!
      end unless delivery_order_items.first(:conditions => ["packing_list_item_id = ?", item_id.to_i])
    end
  end

  def remove_item(item)
    item.each do |item_id, content|
      if content[:selected]
        i = delivery_order_items.find(item_id)
        i.destroy
      end
    end
 end


  private

  def check_packing_list_status
    check = true
    p = packing_list
    p.packing_list_items.each do |i|
      check = false unless i.full_delivery?
    end
    if check
      p.imported = true
      p.save!
    end
  end

  def setup
    generate_number
    assign_customer
    assign_salesman
  end

  def generate_number
    setting = Setting.first
    setting.delivery_order_last_number += 1
    setting.save!
    self.delivery_order_number = setting.delivery_order_code + setting.delivery_order_last_number.to_s
  end

  def assign_customer
    self.customer_id = packing_list.customer_id
  end

  def assign_salesman
    self.salesman_id = packing_list.salesman_id
  end

 def update_name
    self.name = delivery_order_number
  end

end
