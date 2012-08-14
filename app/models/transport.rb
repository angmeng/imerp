class Transport < ActiveRecord::Base
   has_many :delivery_orders
   belongs_to :city


  def self.options
    result = order("name").all
    dummy = new
    dummy.id = 0
    dummy.name = "None"
    result.insert(0, dummy)
    result
  end
end
