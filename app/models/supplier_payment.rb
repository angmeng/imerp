class SupplierPayment < ActiveRecord::Base
  has_many   :supplier_payment_items
  belongs_to :supplier
  belongs_to :payment_method

  before_create :generate_supplier_payment_number
  attr_reader :purchase_order_tokens
  scope :unsettled, where(:settled => false)


 
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
 
  def add_autocomplete_purchase_order(item)
     error_msg = ""
      item_ids = item[:purchase_order_tokens].split(",")
      item_ids.uniq.each do |i|
      found = PurchaseOrder.find(i.to_i) rescue nil
       if found.supplier_id == supplier_id
        if supplier_payment_items.first(:conditions => ["purchase_order_id =?", found.id])
           error_msg << found.purchase_order_number + " already exist <br/>"
        else
          supplier_payment_items.create!(:purchase_order_id => i.to_i) if found
        end
      else
        error_msg << found.purchase_order_number + " not belonging to supplier of payment.<br>"
      end
      end
   error_msg
   end
 
  
 def add_purchase_order(item)
     error_msg = ""
    item.each do |purchase_order_id, content|
      if content[:selected].to_i == 1
        if supplier_payment_items.first(:conditions => ["purchase_order_id = ?", purchase_order_id])
          error_msg << PurchaseOrder.find(purchase_order_id).purchase_order_number + " already exist <br/>"
        else
          i = supplier_payment_items.new
          i.purchase_order_id = purchase_order_id.to_i
          i.amount = i.purchase_order.total_amount
          i.save!
        end
      end
    end
    error_msg
 end

 def update_items(item)
   error_msg=""
    item.each do |item_id, content|
     unless content[:paid_amount].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:paid_amount].blank?
      i = supplier_payment_items.find(item_id.to_i)
      balance = i.purchase_order.total_amount - i.total_paid_amount
      i.remark = content[:remark]
      i.save!
     if content[:paid_amount].to_f > balance + i.paid_amount
         error_msg << "paid amount exceed"
     else
        i.paid_amount = content[:paid_amount].to_f

        i.save!
    end
  end
    end
  error_msg
end

 def remove_item(item)
   error_msg=""
   item.each do |inv_id, content|
    if content[:selected].to_i == 1
      i = supplier_payment_items.find(inv_id)
      po = PurchaseOrder.find(i.purchase_order_id)
        unless po.payment_paid?
         i.destroy
        else
          error_msg << po.purchase_order_number + " already sattled and unsuccessfully delete"
       end
    end
  end
   error_msg
 end

def verify_for_destroy
    self.voided = true
    save!
end

def payment_paid
   if posted?
     return false
   else
      supplier_payment_items.each do |i|
         po = i.purchase_order
         total = 0.00
         po.supplier_payment_items.each do |payment|
            total += payment.paid_amount
         end
       if total == po.total_amount
        po.payment_paid = true
        po.save!
       end
   end
   self.posted = true
   save!
  end
 end
 
def check_supplier(supplier_payment)

  if supplier_payment_items.any?
    if supplier_id == supplier_payment[:supplier_id].to_i
      update_attributes(supplier_payment)
      return true
    else
      return false
    end
  else
    update_attributes(supplier_payment)
    return true
  end
end

def remove_payment_item(item)
    item.each do |item_id, content|
      if content[:selected]
        i = supplier_payment_items.find(item_id)
        i.destroy
      end
    end
end

def check_settle
      error_count = 0
      if self.payment_method_id.nil?
        error_count += 1
      end
      if supplier_payment_items.any?
      supplier_payment_items.each do |i|
           if i.paid_amount == 0
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

def supplier_payment(supplier_payment)
    found = PaymentMethod.find(supplier_payment[:payment_method_id])

          if found.check
             self. cheque_number = (supplier_payment[:spm_number])
             self. bank = (supplier_payment[:bank])
             self.cheque_date = (supplier_payment[:spm_date])
             self.payment_method_id = (supplier_payment[:payment_method_id])
             self.supplier_payment_date = (supplier_payment[:supplier_payment_date])
             self.remark = (supplier_payment[:remark])
             save!
          else
             self. cheque_number = nil
             self. bank = nil
             self.cheque_date = nil
             self.payment_method_id = (supplier_payment[:payment_method_id])
             self.supplier_payment_date = (supplier_payment[:supplier_payment_date])
             self.remark = (supplier_payment[:remark])
             save!
          end
         
        end
  

private

def generate_supplier_payment_number
    setting = Setting.first
    setting.supplier_payment_last_number += 1
    setting.save!
    self.supplier_payment_number = setting.supplier_payment_code + setting.supplier_payment_last_number.to_s
 end

end