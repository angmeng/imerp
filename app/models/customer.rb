class Customer < ActiveRecord::Base
  has_many :purchase_requisition_items
  has_many :sales_orders
  has_many :purchase_orders
  has_many :packing_lists
  has_many :delivery_orders
  has_many :customer_debit_notes
  has_many :customer_credit_notes
  has_many :customer_payments
  belongs_to :price_level
  belongs_to :city

  validates :code, :presence => true, :uniqueness => true
  attr_accessor :prepared_requisition_items

  def code_name
    code + " | " + name
  end

  def self.selections
    result = all
    dummy = Customer.new
    dummy.id = 0
    dummy.name = "None"
    result.insert(0, dummy)
    result.map {|c| [c.name, c.id]}
  end


end
