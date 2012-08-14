class Invoice < ActiveRecord::Base
  has_many   :invoice_items
  has_many   :customer_payment_items
  belongs_to :customer
  belongs_to :sales_order


  before_create :generate_inv_number
  before_save    :update_name
  attr_reader :delivery_order_tokens
  scope(:active, where(:voided => false))
  scope(:hidden, where(:voided => true))
  scope(:unsettled, where(:voided => false, :payment_paid => false))
  scope(:had_settled, where(:voided => false, :settled => true))
  scope(:unimported, where(:voided => false, :settled => false, :imported => false))
  scope(:unpaid, where(:payment_paid => false,:imported => true))

  def mark_as_completed
    self.settled = true
    save!
  end
  def current_status
     if settled?
        "<em style='color:green'>Complete</em>"
      else
        "<em style='color:blue'>Processing</em>"
      end
  end
  def payment_status
     if payment_paid?
        "<em style='color:purple'>Paid</em>"
      else
        "<em style='color:orange'>Unpaid</em>"
      end
  end
  def void_status
    if voided?
       "<em style='color:red'>Voided</em>"
       else
        "<em style='color:brown'>Unvoided</em>"
      end
   
  end
  
  def total_amount
    total = 0.0
    invoice_items.each do |c|
      total += c.total_amount
    end
    total
  end

  def total
    invoice_items.inject(0) { |sum, c| sum += c.total }
  end
  
 def add_autocomplete_delivery_order(item)
    error_msg = ""
      item_ids = item[:delivery_order_tokens].split(",")
      item_ids.uniq.each do |i|
      found = DeliveryOrder.find(i.to_i) rescue nil
      if found.customer_id == customer_id
        if invoice_items.first(:conditions => ["delivery_order_id =?", found.id])
           error_msg << found.delivery_order_number + " already exist <br>"
        else
            if DeliveryOrder.find(i.to_i).settled?
              invoice_items.create!(:invoice_id => i.to_i) if found
           else
              error_msg << "DO unsuccessfully added. " + DeliveryOrder.find(i.to_i).delivery_order_number + " still on processing."
            end
        end
      else
        error_msg << found.delivery_order_number + " not belonging to customer of invoice.<br>"
      end
      end
   error_msg
   end
  

   def add_do(item)
    error_msg = ""
    item.each do |do_id, content|
      if content[:selected].to_i == 1
        if invoice_items.first(:conditions => ["delivery_order_id = ?", do_id])
          error_msg << DeliveryOrder.find(do_id).delivery_order_number + " already exist <br />"
        else
          if DeliveryOrder.find(do_id).settled?
          i = invoice_items.new
          i.delivery_order_id = do_id.to_i
          i.amount = i.delivery_order.total_amount
         
          i.save!
          else
            error_msg << "DO unsuccessfully added. " + DeliveryOrder.find(do_id).delivery_order_number + " still on processing."
         end
       end
      end
    end
    error_msg
  end

   def update_item(item)
    item.each do |item_id, content|
      unless content[:remark].blank?
        i = invoice_items.find(item_id.to_i)
        i.remark = content[:remark]

        i.save!
      end
    end
  end

  def remove_item(item)
    item.each do |inv_id, content|
      if content[:selected].to_i == 1
        i = invoice_items.find(inv_id)
        i.destroy
      end
    end
  end

  def remove_do(item)
      item.each do |inv_id, content|
      if content[:selected].to_i == 1
        i = invoice_items.find(inv_id)
        i.destroy
      end
    end
  end

  def verify_for_destroy
    self.voided = true
    save!
  end

  def check_customer(invoice)
    if invoice_items.any?
    if customer_id == invoice[:customer_id].to_i
      update_attributes(invoice)
      return true
    else
      return false
    end
  else
    update_attributes(invoice)
    return true
  end
end


 def update_info(invoice)
   update_attributes(invoice)
 end

  private

  def generate_inv_number
    setting = Setting.first
    setting.invoice_last_number += 1
    setting.save!
    self.invoice_number = setting.invoice_code + setting.invoice_last_number.to_s
  end
  
  def update_name
    self.name = invoice_number
  end

  
 

end
