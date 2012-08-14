module ProductsHelper
  
  def show_options
    output = "<ol>"   
    output << generate_content(@product.is_stock?, "Stock")
    output << generate_content(@product.is_sales?, "Sales")
    output << generate_content(@product.is_open_item?, "Open Item")
    output << generate_content(@product.is_taxable?, "Taxable")
    output << generate_content(@product.is_disposal?, "Disposal")
    output << generate_content(@product.is_taxable?, "Taxable")
    output << generate_content(@product.has_serial_no?, "Has Serial No")
    output << generate_content(@product.allow_discount_below_cost?, "Discount below cost")
    output << generate_content(@product.allow_negative_amount?, "Negative amount")
    output << generate_content(@product.allow_quantity_discount?, "Quantity discount")
    output << generate_content(@product.allow_free_of_charge?, "Free of charge")
    output << generate_content(@product.allow_zero_selling_price?, "Zero selling price")
    output << generate_content(@product.allow_zero_purchase_price?, "Zero purchase price")
    output << generate_content(@product.allow_sales_discount?, "Sales discount")
    output << generate_content(@product.allow_return_to_vendor?, "Return to vendor")
    output << generate_content(@product.cost_include_freight_charge?, "Cost include freight charge")
    output << generate_content(@product.cost_include_insurance?, "Cost include insurance")
    output << "</ol>"
   
  end
  
  private
  
  def generate_content(check, target_word)
    if check
      content_tag :li, target_word, :style => "list-style-type: circle"
    else
      ""
    end
  end
  
end
