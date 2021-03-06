class SupplierDebitNoteItem < ActiveRecord::Base
  belongs_to :supplier_debit_note
  belongs_to :product
  belongs_to :product_uom
  belongs_to :stock_location

  def total
    unit_price * quantity
  end

end
