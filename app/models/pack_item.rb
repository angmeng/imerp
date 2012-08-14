class PackItem < ActiveRecord::Base
  has_many :pack_item_subitems
  belongs_to :pack
  belongs_to :product
  belongs_to :product_uom
  belongs_to :stock_location

  after_create :add_subitem
  after_destroy :destroy_subitem

  def update_subitem(item)
    item.each do |item_id, content|
     
            i = pack_item_subitems.find(item_id.to_i)
            i.stock_location_id = content[:stock_location_id].to_i
           
            i.save!
      
  end
  end

  

  private
  def add_subitem
    found = MixedProduct.where("parent_id = ? and parent_uom_id = ? ", product_id, product_uom_id).first
     MixedProduct.where("parent_id = ? and parent_uom_id = ?", product_id , product_uom_id).all.each do |mix_item|
       found_cost = ProductUomItem.first(:conditions => ["product_id = ? and product_uom_id = ?", mix_item.product_id, mix_item.product_uom_id])
      pack_item_subitems.create!(:product_id => mix_item.product_id , :product_uom_id => mix_item.product_uom_id ,:quantity => mix_item.quantity, :cost => found_cost.current_cost, :stock_location_id => 0) if found
     end
   end

  def destroy_subitem
    found = PackItemSubitem.where("pack_item_id = ?", id).all
    found.each do |c|
      c.destroy
    end
    

    end
   end
 

