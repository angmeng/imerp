class PurchaseOrder < ActiveRecord::Base
  has_many   :purchase_order_items
  has_many   :goods_receive_notes
  has_many   :supplier_payment_items
  belongs_to :supplier
  belongs_to :purchase_requisition
  has_many   :product_virtual_movements, :as => :virtual_movement

  before_create :generate_po_number
  before_save    :update_name
 
  scope(:active, where(:voided => false))
  scope(:hidden, where(:voided => true))
  scope(:unsettled, where(:voided => false, :payment_paid => false, :settled => false, :imported=>false))
  scope(:had_settled, where(:voided => false, :imported => true))
  scope(:unimported, where(:voided => false, :settled => false, :imported => false))
  scope(:unpaid, where(:imported => true, :payment_paid => false))

  

  def mark_as_completed
    self.settled = true
    save!
  end

  def current_status
     if imported?
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


  def total_amount
    total = 0.0
    purchase_order_items.each do |c|
      total += c.total
    end
    total
  end

  def total
    purchase_order_items.inject(0) { |sum, c| sum += c.total }
  end

  def verify_for_destroy
    self.voided = true
    save!
  end

  def check_quantity
    result = []
    purchase_order_items.each do |i|
      total_delivered = 0
      i.goods_receive_note_items.each do |p|
        total_delivered += p.delivered_quantity
      end
      balance = i.quantity - total_delivered
      if balance > 0
        result << i
      end
    end
    result
  end

  private

  def generate_po_number
    setting = Setting.first
    setting.purchase_order_last_number += 1
    setting.save!
    self.purchase_order_number = setting.purchase_order_code + setting.purchase_order_last_number.to_s
  end

  def update_name
    self.name = purchase_order_number
  end

end
