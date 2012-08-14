class Salesman < ActiveRecord::Base
 has_many :delivery_orders
 has_many :packing_lists
 has_many :sales_orders
 belongs_to :city

  def self.options
    result = all
    dummy = new
    dummy.id = 0
    dummy.name = "None"
    result.insert(0, dummy)
    result
  end

end
