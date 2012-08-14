class Supplier < ActiveRecord::Base
  has_many :purchase_requisition_items
  has_many :purchase_orders
  has_many :supplier_credit_notes
  has_many :supplier_debit_notes
  has_many :supplier_payments
  belongs_to :city
  validates :code, :name, :presence => true, :uniqueness => true
  attr_accessor :prepared_requisition_items
  
  def code_name
    code + " | " + name
  end

  def self.selections
    result = all
    dummy = Supplier.new
    dummy.id = 0
    dummy.name = "None"
    result.insert(0, dummy)
    result.map {|c| [c.name, c.id]}
  end

end
