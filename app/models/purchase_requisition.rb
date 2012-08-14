class PurchaseRequisition < ActiveRecord::Base
  has_many :purchase_requisition_items
  has_many :confirmed_items, :conditions => "confirmed = true", :class_name => "PurchaseRequisitionItem"
  has_many :purchase_orders
  belongs_to :issued_user, :class_name => "User"
  belongs_to :approved_user, :class_name => "User"

  validates :pr_date, :presence => true
  before_create :generate_pr_number

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

  def add_autocomplete_item(item, supplier)
   item_ids = item[:product_tokens].split(",")
    item_ids.uniq.each do |i|
      found = Product.find(i.to_i) rescue nil
       purchase_requisition_items.create!(:product_id => i.to_i,:supplier_id =>supplier.id,:product_uom_id => 0) if found
      end
    end
  
  
  def add_item(item,supplier)
     error_msg = ""
    item.each do |p_id, content|
      if content[:selected].to_i == 1
         if content[:product_uom_id].to_i > 0
            if purchase_requisition_items.first(:conditions => ["product_id = ? and product_uom_id = ? and supplier_id = ?", p_id , content[:product_uom_id].to_i, supplier.id ])
             error_msg << Product.find(p_id.to_i).code + " - " + ProductUom.find(content[:product_uom_id].to_i).name + " - " + Supplier.find(supplier.id).name + " - is already exist <br>"
            else
              i = purchase_requisition_items.new
               unless content[:product_uom_id].blank?
                 i.product_uom_id = content[:product_uom_id].to_i
               end
              i.supplier_id = supplier.id
              i.product_id = p_id.to_i
              i.save!    
            end
         else
           i = purchase_requisition_items.new
               unless content[:product_uom_id].blank?
                 i.product_uom_id = content[:product_uom_id].to_i
               end
              i.supplier_id = supplier.id
              i.product_id = p_id.to_i
              i.save!
          end
         end
        end
    error_msg
  end

  def update_item(item)
    error_msg = ""
    item.each do |item_id, content|
      i = purchase_requisition_items.find(item_id.to_i)
      if content[:product_uom_id].to_i > 0
          if  purchase_requisition_items.where("id != ? and product_id = ? and product_uom_id = ? and supplier_id = ?", item_id, i.product_id, content[:product_uom_id], i.supplier_id).first
            error_msg << Product.find(i.product_id.to_i).code + " - " + ProductUom.find(content[:product_uom_id].to_i).name + " - " + Supplier.find(i.supplier_id).name + " - is already exist <br>"
          else
            i.product_uom_id = content[:product_uom_id].to_i
            i.remark = content[:remark]
              unless content[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:quantity].blank? or content[:unit_price].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:unit_price].blank?
              i.quantity = content[:quantity].to_i 
              i.unit_price = content[:unit_price].to_f
              end
          end
          
          if content[:selected]
              i.confirmed = true
          else
              i.confirmed = false
          end
      else
            i.product_uom_id = content[:product_uom_id].to_i
            i.remark = content[:remark]
              unless content[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:quantity].blank? or content[:unit_price].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:unit_price].blank?
                i.quantity = content[:quantity].to_i 
                i.unit_price = content[:unit_price].to_f
              end
      end
      
      if content[:selected]
          i.confirmed = true
      else
          i.confirmed = false
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
        i = purchase_requisition_items.find(item_id.to_i)
        i.confirmed = true
        i.save!
      end
    end
  end

  def remove_item(item)
    item.each do |item_id, content|
      if content[:selected]
        i = purchase_requisition_items.find(item_id)
        i.destroy
      end
    end
 end

  def send_for_approval
    unless confirmed_items.empty?
      self.status_id = WAITING_FOR_APPROVAL
      save!
    else
      return false
    end
  end

  def check_settle
      error_count = 0
      purchase_requisition_items.each do |i|
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
    prepare_suppliers
    generate_po_for_suppliers
  end

  def regenerate_po
    prepare_suppliers
    regenerate_po_for_suppliers
  end

  def total_amount
    purchase_requisition_items.all(:conditions => "confirmed = true").inject(0) {|sum, c| sum += c.total }
  end

  def verify_for_destroy
    self.void = true
    save!
  end
  def remove_pr_item(item)
    item.each do |item_id, content|
      if content[:selected]
        i = purchase_requisition_items.find(item_id)
        i.destroy
      end
    end
 end
  
   


  private

  def generate_pr_number
    setting = Setting.first
    setting.purchase_requisition_last_number += 1
    setting.save!
    self.pr_number = setting.purchase_requisition_code + setting.purchase_requisition_last_number.to_s
  end

  def prepare_suppliers
    @result = []
    confirmed_items.each do |item|
      found = false
      @result.each do |s|
        if s.id == item.supplier_id
          found = true
          s.prepared_requisition_items << item
        end
      end
      unless found
        s = item.supplier
        s.prepared_requisition_items = []
        s.prepared_requisition_items << item
        @result << s
      end
    end
  end

  def generate_po_for_suppliers
    @result.each do |r|
      r.prepared_requisition_items.each do |item|
        if item.product.starred?
          po = purchase_orders.first(:conditions => ["supplier_id = ? and starred = true", r.id])
          po = purchase_orders.create!(:starred => true, :supplier_id => r.id, :purchase_order_date => Date.today, :term => r.term) unless po
        else
          po = purchase_orders.first(:conditions => ["supplier_id = ? and starred = false", r.id])
          po = purchase_orders.create!(:starred => false, :supplier_id => r.id, :purchase_order_date => Date.today, :term => r.term) unless po
        end
        po_item = po.purchase_order_items.new
        po_item.product_id = item.product_id
        po_item.product_uom_id = item.product_uom_id
        po_item.remark = item.remark
        po_item.unit_price = item.unit_price
        po_item.quantity = item.quantity
        po_item.purchase_requisition_item_id = item.id
        po_item.save!
        #product = Product.find(item.product_id)
        virtual = ProductVirtualMovement.new(:virtual_movement => po)
        virtual.movement_date = po.purchase_order_date
        virtual.product_id = po_item.product_id
        virtual.product_uom_id = po_item.product_uom_id
        virtual.quantity = po_item.quantity
        virtual.stock_location_id = 0
        virtual.description = ProductVirtualMovement::ADD_PO_DESC
        virtual.save!
        
        item.purchase_order_id = po.id
        item.save!
      end
    end
  end

  def regenerate_po_for_suppliers
     po_items_ids = []
     g_items_ids = []
     @result.each do |r|
      r.prepared_requisition_items.each do |item|
        if item.product.starred?
          po = purchase_orders.first(:conditions => ["supplier_id = ? and starred = true", r.id])
          po = purchase_orders.create!(:starred => true, :supplier_id => r.id, :purchase_order_date => Date.today, :term => r.term) unless po
        else
          po = purchase_orders.first(:conditions => ["supplier_id = ? and starred = false", r.id])
          po = purchase_orders.create!(:starred => false, :supplier_id => r.id, :purchase_order_date => Date.today, :term => r.term) unless po
        end
        po_item = item.purchase_order_item

        unless po_item
          po_item = po.purchase_order_items.new
          found_item = po.product_virtual_movements.new(:product_id => item.product_id, :product_uom_id => item.product_uom_id)
        else
          found_item = po.product_virtual_movements.first(:conditions => ["product_id = ? and product_uom_id = ?", item.product_id, item.product_uom_id])
        end
        po_item.purchase_order_id = po.id
        po_item.product_id = item.product_id
        po_item.remark = item.remark
        po_item.unit_price = item.unit_price
        po_item.quantity = item.quantity
        
        found_item.quantity = item.quantity
        if found_item.mixed?
          found_item.product.mixed_items.each do |mi|
            po.product_virtual_movements.first(:conditions => ["product_id = ? and product_uom_id = ?", item.product_id, item.product_uom_id])
          end
        end
        found_item.save!

        po_item.product_uom_id = item.product_uom_id
        po_item.purchase_requisition_item_id = item.id
        po_item.save!
        po_items_ids << po_item.id
        item.purchase_order_id = po.id
        item.save!

          po.goods_receive_notes.each do |g|
            g.goods_receive_note_items.all(:conditions => ["purchase_order_item_id = ?", po_item.id]).each do |g_item|
              g_item.product_uom_id = po_item.product_uom_id
              g_item.product_id = po_item.product_id
              g_item.purchase_order_item_id = po_item.id
              g_item.quantity = po_item.quantity
              g_item.save!
              g_items_ids << g_item.id
            end
           end

       end
     end
     purchase_orders.all.each do |po|
        po.purchase_order_items.each do |item|
          
          unless po_items_ids.include?(item.id)
            item.destroy
            found_item = po.product_virtual_movements.first(:conditions => ["product_id = ? and product_uom_id = ?", item.product_id, item.product_uom_id])
            found_item.destroy if found_item
          end
        end
        po.goods_receive_notes.each do |deo|
          deo.goods_receive_note_items.each do |gi|
            gi.destroy unless g_items_ids.include?(gi.id)
          end
        end
      end

  end
  
end








