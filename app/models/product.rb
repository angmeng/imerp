class Product < ActiveRecord::Base
  #require 'csv'
  belongs_to :product_model
  belongs_to :product_brand
  belongs_to :product_category
  belongs_to :product_kind
  belongs_to :product_department
  has_many :stock_locations
  has_many :product_racks, :through => :stock_locations
  has_many :product_locations, :through => :product_racks
  has_many :product_uom_items
  has_many :product_uoms, :through => :product_uom_items
  has_many :mixed_products
  has_many :mixed_items, :class_name => "MixedProduct", :foreign_key => :parent_id
  has_many :products, :through => :mixed_items
  has_many :purchase_requisition_items
  has_many :sales_order_items
  has_many :purchase_order_items
  has_many :packing_list_items
  has_many :delivery_order_items
  has_many :supplier_credit_note_items
  has_many :supplier_debit_note_items
  has_many :customer_credit_note_items
  has_many :customer_debit_note_items
  has_many :stock_adjustment_items
  has_many :stock_transfer_items
  has_many :stock_disposal_items
  has_many :product_virtual_movements
  has_many :product_costings
  has_many :pack_items
  has_many :pack_item_subitems
  
  validates :code, :presence => true, :length => {:maximum => 45},
                   :uniqueness => true
  validates :product_kind_id, :presence => true
  
  after_create  :setup
  before_create :generate_in_house_code
  before_save    :update_name
  scope :active, where("disabled = false and deleted = false")
  scope :deleted, where("deleted = true")
  scope :active_normal_products, joins(:product_kind).where("products.disabled = false and products.deleted = false and product_kinds.name != 'Mixed'") 
 

  search_methods :active_normal_products

  def uom_status
    found = product_uom_items.where("default_uom = true").order("conversion").first
    if found
      total = found.stock_counts.inject(0) {|sum, item| sum += item.quantity}
      result = found.product_uom.name + " (" + total.to_s + ")"
    else
      result = "Not define"
    end
    result
  end

  def default_uom_quantity
    found = product_uom_items.where("default_uom = true").first
    if found
      total = found.stock_counts.inject(0) {|sum, item| sum += item.quantity}
    end
    total
  end



  def collect_virtual_quantity
    result = []
    product_virtual_movements.each do |i|
      found = ProductUomItem.first(:conditions => ["product_id = ? and product_uom_id = ?", i.product_id, i.product_uom_id])
      
      if found
        checked = false
        result.each do |r|
          if r.product_uom_id == found.product_uom_id
            checked = true
            if i.virtual_movement_type == "PackingList"
              r.virtual_packing_quantity += i.quantity
            elsif i.virtual_movement_type == "PurchaseOrder"
              r.virtual_order_quantity += i.quantity
            end
          end
        end
        if checked == false
          new_item = ProductUomItem.new(:product_id => i.product_id, :product_uom_id => i.product_uom_id)

          if i.virtual_movement_type == "PackingList"
            new_item.virtual_packing_quantity = i.quantity
            new_item.virtual_order_quantity = 0
          elsif i.virtual_movement_type == "PurchaseOrder"
            new_item.virtual_order_quantity = i.quantity
            new_item.virtual_packing_quantity = 0
          end
          result << new_item
        end
      end
      
    end
    result.each do |r|
      on_hand_item = StockCount.first(:conditions => ["product_id = ? and product_uom_id = ?", r.product_id, r.product_uom_id])
      if on_hand_item
        r.on_hand_quantity = on_hand_item.quantity
      else
        r.on_hand_quantity = 0
      end
    end

    result
  end

  def stock_location_options
    stock_locations.map {|c| [c.product_rack.name, c.id]}
  end

  def product_uom_options
    result = product_uoms
    dummy = ProductUom.new
    dummy.id = 0
    dummy.name = "None"
    result.insert(0, dummy)
    result
  end

  def code_name
    code + " | " + full_description
  end
  
  def self.filter(items, search_products)
    result = []
    search_products.each do |p|
      result << p unless items.include?(p)
    end
    result
  end
  
  def stock_for_mixed(page, search_products)
    page ||= 1
    result = []
    search_products.each do |p|
      result << p unless products.include?(p)
    end
    result.paginate(:page => page, :per_page => 20)
  end
  
  def collect_minimum_uom(target)
    found = product_uom_items.first(:conditions => ["id != ?", target.id], :order => 'conversion')
    unless found.conversion < target.conversion
      found = nil
    end if found
    found
  end
  
  def set_destroy
    self.deleted = true
    self.disabled = true
    save!
  end
  
  def is_mixed?
    product_kind.name.include?("Mixed")
  end

  def add_item(item)
    item.each do |p_id, content|
      if content[:selected].to_i == 1
        i = stock_locations.new
        i.product_id = id
        i.product_rack_id = p_id.to_i
        i.save!
      end
    end
  end

  def remove_product(item)
    item.each do |item_id, content|
      if content[:selected]
        i = stock_locations.find(item_id)
        i.destroy
      end
    end
 end


  
  
  private
  
  def setup
    update_setting
    check_mixed_items
    create_default_uoms
  end

  def create_default_uoms
    ProductUom.default_uoms.each do |i|
      i.product_uom_items.create!(:product_id => id)
    end
  end
  
  def check_mixed_items
    unless is_mixed?
      mixed_products.destroy_all
    end
  end
  
  def update_setting
    s = Setting.first
    s.product_last_number += 1
    s.save!
  end
  
  def generate_in_house_code
    self.in_house_code = Setting.first.new_inhouse_code
  end

  def update_name
    self.name = code
  end
 
end
