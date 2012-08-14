class ProductUom < ActiveRecord::Base
  has_many :product_uom_items, :dependent => :destroy
  has_many :products, :through => :product_uom_items
  has_many :supplier_credit_note_items
  has_many :supplier_debit_note_items
  has_many :customer_credit_note_items
  has_many :customer_debit_note_items
  has_many :stock_adjustment_items
  has_many :stock_transfer_items
  has_many :stock_disposal_items
  has_many :mixed_products
  has_many :product_costings
  has_many :pack_items
  has_many :pack_item_subitems
  
  validates :name, :presence => true, :length => {:maximum => 45},
                   :uniqueness => true
                     
  #after_create :setup

  scope :default_uoms, where("builtin = true")
  
  private
  
  def setup
    update_default_uoms
  end

  def update_default_uoms
#    if default?
#      ProductUomItem.where("product").each do |p|
#
#      end
#    else
#
#    end
  end
  
  
  
  
end
