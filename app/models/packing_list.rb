class PackingList < ActiveRecord::Base
  has_many :packing_list_items
  has_many :delivery_orders
  belongs_to :customer
  belongs_to :salesman
  belongs_to :sales_order
  has_many   :product_virtual_movements, :as => :virtual_movement

  before_create :generate_po_number

  scope(:active, where(:voided => false))
  scope(:hidden, where(:voided => true))
  scope(:unsettled, where(:voided => false, :settled => false))
  scope(:had_settled, where(:voided => false, :imported => true))
  scope(:unimported, where(:voided => false, :settled => false, :imported => false))

  def mark_as_completed
    self.settled = true
    save!
  end

  def current_status
    imported ? "<em style='color:green'>Completed</em>" : "<em style='color:blue'>Processing</em>"
  end

  def total
    packing_list_items.inject(0) { |sum, c| sum += c.total }
  end

  def verify_for_destroy
    self.voided = true
    save!
  end

  def check_quantity
    result = []
    packing_list_items.each do |i|
      total_delivered = 0
      i.delivery_order_items.each do |p|
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
    setting.packing_list_last_number += 1
    setting.save!
    self.packing_list_number = setting.packing_list_code + setting.packing_list_last_number.to_s
  end

end
