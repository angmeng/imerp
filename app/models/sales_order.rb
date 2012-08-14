class SalesOrder < ActiveRecord::Base
  has_many :sales_order_items
  has_many :confirmed_items, :conditions => "confirmed = true", :class_name => "SalesOrderItem"
  has_many :packing_lists
  belongs_to :salesman
  belongs_to :customer
  belongs_to :issued_user, :class_name => "User"
  belongs_to :approved_user, :class_name => "User"

  validates :sales_order_date, :presence => true
  
  before_create :generate_so_number

  attr_reader :customer_tokens
  attr_reader :product_tokens
  

  
  PROCESSING = 0
  WAITING_FOR_APPROVAL = 1
  APPROVED = 2

  def is_processing?
    status_id == PROCESSING
  end

  def waiting_for_approval?
    status_id == WAITING_FOR_APPROVAL
  end

  def approved?
    status_id == APPROVED
  end

  def status
    case status_id
    when PROCESSING
      "<em style='color:blue'>Processing</em>"
    when WAITING_FOR_APPROVAL
      "<em style='color:orange'>Waiting for Approval</em>"
    when APPROVED
      "<em style='color:green'>Approved</em>"
    else
      "<em style='color:red'>Unknown</em>"
    end
  end

  def void_status
    if void?
      "<em style='color:red'>Voided</em>"
    else
      "<em style='color:brown'>Unvoided</em>"
    end


 end

 def add_autocomplete_item(item)
   error_msg = ""
    item_ids = item[:product_tokens].split(",")
    #target = item_ids[0]
    item_ids.uniq.each do |i|
      found = Product.find(i.to_i) rescue nil
      found_uom = ProductUomItem.first(:conditions => ["product_uom_id = ? and product_id = ?", item[:product_uom_id],i.to_i])
      if found_uom
        if sales_order_items.first(:conditions => ["product_id = ? and product_uom_id = ? ", i.to_i , item[:product_uom_id].to_i ])
            error_msg << Product.find(i.to_i).code + " - " + ProductUom.find(item[:product_uom_id].to_i).name + " - is already exist <br>"
        else
            if item[:discounts].blank?
             sales_order_items.create!(:product_id => i.to_i,:unit_price =>item[:unit_price] ,:product_uom_id => item[:product_uom_id], :discounts => 0, :quantity => item[:quantity] ) if found
            else
               sales_order_items.create!(:product_id => i.to_i,:unit_price =>item[:unit_price] ,:product_uom_id => item[:product_uom_id], :discounts => item[:discounts], :quantity => item[:quantity] ) if found
            end
        end
     else
       error_msg << Product.find(i.to_i).code + " - " + ProductUom.find(item[:product_uom_id].to_i).name + " - is not exist <br>"
     end
   end
  error_msg
 end

   

  def add_item(item)
     error_msg = ""
    item.each do |p_id, content|
      if content[:selected].to_i == 1
        if content[:product_uom_id].to_i > 0
          if sales_order_items.first(:conditions => ["product_id = ? and product_uom_id = ? ", p_id , content[:product_uom_id].to_i ])
           error_msg << Product.find(p_id.to_i).code + " - " + ProductUom.find(content[:product_uom_id].to_i).name + " - is already exist <br>"
          else
            i = sales_order_items.new
              unless content[:product_uom_id].blank?
                i.product_uom_id = content[:product_uom_id].to_i
               end
                
                i.product_id = p_id.to_i
                i.unit_price = i.price
                i.discounts = 0
                i.save!
              end
        else
           i = sales_order_items.new
              unless content[:product_uom_id].blank?
                i.product_uom_id = content[:product_uom_id].to_i
               end
             
                i.product_id = p_id.to_i
                i.unit_price = i.price
                i.discounts = 0
                i.save!
         end
        end
    end
 
  error_msg
  end

  def update_item(item)
      error_msg = ""
    item.each do |item_id, content|
     i = sales_order_items.find(item_id.to_i)
     if content[:product_uom_id].to_i > 0
      if sales_order_items.where("id != ? and product_id = ? and product_uom_id = ?", item_id, i.product_id, content[:product_uom_id]).first
        error_msg << Product.find(i.product_id.to_i).code + " - " + ProductUom.find(content[:product_uom_id].to_i).name + " - " + Customer.find(i.customer_id).name + " - is already exist <br>"
        else
        i.product_uom_id = content[:product_uom_id].to_i
         unless content[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:quantity].blank? or content[:unit_price].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:unit_price].blank? 
            i.quantity = content[:quantity].to_i
            i.remark = content[:remark]
              if  content[:discount].blank?
                 i.discounts = 0
              else
                 i.discounts = content[:discount]
              end
             if content[:unit_price].to_f == 0.00  and content[:product_uom_id].to_i > 0
              found_cust = Customer.first(:conditions => ["id = ?", customer_id])
              pricing = ProductPricing.first(:conditions => ["price_level_id = ? and product_id = ? and product_uom_id = ?", found_cust.price_level_id, i.product_id, i.product_uom_id])
              i.unit_price = pricing.selling_price if pricing
            else
              i.unit_price = content[:unit_price].to_f
            end

        end
        if content[:selected]
          i.confirmed = true
        else
          i.confirmed = false
        end
      end
     else
       i.product_uom_id = content[:product_uom_id].to_i
         unless content[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:quantity].blank? or content[:unit_price].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:unit_price].blank?
            i.quantity = content[:quantity].to_i
            i.remark = content[:remark]
              if  content[:discount].blank?
                 i.discounts = 0
              else
                 i.discounts = content[:discount]
              end
             if content[:unit_price].to_f == 0.00  and content[:product_uom_id].to_i > 0
              found_cust = Customer.first(:conditions => ["id = ?", i.customer_id])
              pricing = ProductPricing.first(:conditions => ["price_level_id = ? and product_id = ? and product_uom_id = ?", found_cust.price_level_id, i.product_id, i.product_uom_id])
              i.unit_price = pricing.selling_price if pricing
            else
              i.unit_price = content[:unit_price].to_f
            end

        end
        if content[:selected]
          i.confirmed = true
        else
          i.confirmed = false
        end
     end
        i.save!
      end
      error_msg
    end


  def confirm_item(item)
    confirmed_items.each do |c|
      c.confirmed = false
      c.save!
    end
    item.each do |item_id, content|
      if content[:selected]
        i = sales_order_items.find(item_id.to_i)
        i.confirmed = true
        i.save!
      end
    end
  end

  def send_for_approval
    unless confirmed_items.empty?
      if salesman
        self.status_id = WAITING_FOR_APPROVAL
        save!
      else
        return false
      end
    else
      return false
    end
  end
  
  def check_settle
      error_count = 0
      sales_order_items.each do |i|
       if i.product_uom_id == 0 or i.quantity == 0 or i.unit_price == 0 
         error_count += 1
       end
      end
      if error_count == 0
        return true
      else
        return false
      end

  end

  def approve(user_id)
    unless confirmed_items.empty?
      self.approved_user_id = user_id
      self.status_id = APPROVED
      save!
    else
     return false
    end
  end

  def generate_po
    prepare_customers
    generate_po_for_customers
  end

  def regenerate_po
    prepare_customers
    regenerate_po_for_customers
  end

  def total_amount
    sales_order_items.all(:conditions => "confirmed = true").inject(0) {|sum, c| sum += c.total }
  end

  def verify_for_destroy
    self.void = true
    save!
  end

 def add_customer(item)
    item.each do |p_id, content|
      if content[:customer_id].to_i == 1
        i = sales_order_items.new
        i.customer_id = p_id.to_i
        i.save!
      end
    end

  end
  def remove_item(item)
    item.each do |item_id, content|
      if content[:selected]
        i = sales_order_items.find(item_id)
        i.destroy
      end
    end
 end
 
 def removed_so_item(item)
    item.each do |item_id, content|
      if content[:selected]
        i = sales_order_items.find(item_id)
        i.destroy
      end
    end
 end

  private

  def generate_so_number
    setting = Setting.first
    setting.sales_order_last_number += 1
    setting.save!
    self.sales_order_number = setting.sales_order_code + setting.sales_order_last_number.to_s
  end

  def prepare_customers
    @result = []
    confirmed_items.each do |item|
      found = false
      @result.each do |s|
        found = true
         s.prepared_requisition_items << item
        end
      unless found
        s = item.customer
        s.prepared_requisition_items = []
        s.prepared_requisition_items << item
        @result << s
      end
    end
  end

  def generate_po_for_customers
    @result.each do |r|
      r.prepared_requisition_items.each do |item|
        if item.product.starred?
          po = packing_lists.first(:conditions => ["customer_id = ? and starred = true", r.id])
          po = packing_lists.create!(:starred => true, :customer_id => r.id, :packing_list_date => Date.today, :term => r.term, :salesman_id => item.sales_order.salesman_id) unless po
        else
          po = packing_lists.first(:conditions => ["customer_id = ? and starred = false", r.id])
          po = packing_lists.create!(:starred => false, :customer_id => r.id, :packing_list_date => Date.today, :term => r.term,:salesman_id => item.sales_order.salesman_id) unless po
        end
        po_item = po.packing_list_items.new
        po_item.product_id = item.product_id
        po_item.product_uom_id = item.product_uom_id
        po_item.remark = item.remark
        po_item.unit_price = item.unit_price
        po_item.quantity = item.quantity
        po_item.sales_order_item_id = item.id
        po_item.discounts = item.discounts
        po_item.save!
        #product = Product.find(item.product_id)
        virtual = ProductVirtualMovement.new(:virtual_movement => po)
        virtual.movement_date = po.packing_list_date
        virtual.product_id = po_item.product_id
        virtual.product_uom_id = po_item.product_uom_id
        virtual.quantity = Engineer.negative(po_item.quantity)
        virtual.stock_location_id = 0
        virtual.description = ProductVirtualMovement::ADD_PACKING_DESC
        virtual.save!

        item.packing_list_id = po.id
        item.save!
      end
    end
  end
  
   def regenerate_po_for_customers
     po_items_ids = []
     g_items_ids = []
     @result.each do |r|
      r.prepared_requisition_items.each do |item|
        if item.product.starred?
          po = packing_lists.first(:conditions => ["customer_id = ? and starred = true", r.id])
          po = packing_lists.create!(:starred => true, :customer_id => r.id, :packing_list_date => Date.today, :term => r.term) unless po
        else
          po = packing_lists.first(:conditions => ["customer_id = ? and starred = false", r.id])
          po = packing_lists.create!(:starred => false, :customer_id => r.id, :packing_list_date => Date.today, :term => r.term) unless po
        end
        po_item = item.packing_list_item
        unless po_item
          po_item = po.packing_list_items.new
          found_item = po.product_virtual_movements.new(:product_id => item.product_id, :product_uom_id => item.product_uom_id)
        else
          found_item = po.product_virtual_movements.first(:conditions => ["product_id = ? and product_uom_id = ?", item.product_id, item.product_uom_id])
        end
        po_item.packing_list_id = po.id
        po_item.product_id = item.product_id
        po_item.remark = item.remark
        po_item.unit_price = item.unit_price
        po_item.quantity = item.quantity

        found_item.quantity = item.quantity
        found_item.save!
        
        po_item.product_uom_id = item.product_uom_id
        po_item.sales_order_item_id = item.id
        po_item.save!
        po_items_ids << po_item.id
        item.packing_list_id = po.id
        item.save!
        
          po.delivery_orders.each do |g|
            g.delivery_order_items.all(:conditions => ["packing_list_item_id = ?", po_item.id]).each do |g_item|
              g_item.product_uom_id = po_item.product_uom_id
              g_item.product_id = po_item.product_id
              g_item.packing_list_item_id = po_item.id
              g_item.quantity = po_item.quantity
              g_item.save!
              g_items_ids << g_item.id
            end
           end

       end
     end
     packing_lists.all.each do |po|
        po.packing_list_items.each do |item|

          unless po_items_ids.include?(item.id)
            item.destroy 
            found_item = po.product_virtual_movements.first(:conditions => ["product_id = ? and product_uom_id = ?", item.product_id, item.product_uom_id])
            found_item.destroy if found_item
          end
        end
        po.delivery_orders.each do |deo|
          deo.delivery_order_items.each do |gi|
            gi.destroy unless g_items_ids.include?(gi.id)
          end
        end
      end
     
  end
end
 #person = SalesOrder.create(:sales_order_date == 30)

  #person.errors[:sales_order_date]
   # => ["cannot contain the characters !@#%*()_-+="]

  #person.errors.to_a
   # => ["Name cannot contain the characters !@#%*()_-+="]



 




