class Setting < ActiveRecord::Base
  validates :company_name, :product_prefix_code, :presence => true, :uniqueness => true
  
  def new_inhouse_code
    product_prefix_code + (product_last_number + 1).to_s
  end
end
