class Engineer
  #gem install rubyzip, nokogiri, spreadsheet, google-spreadsheet-ruby, spreadsheet-excel
  #apt-get install libxslt1-dev

  def self.negative(num)
    num - (num * 2)
  end

  def self.import_product
    #require 'roo'
    file = RAILS_ROOT + "/public/product.xls"
    oo = Excel.new(file)
    oo.default_sheet = oo.sheets.first
    2.upto(oo.last_row) do |line|
      code       = oo.cell(line,'A')
      desc       = oo.cell(line,'B')
      short_desc = oo.cell(line,'C')
      #p_kind     = oo.cell(line,'D')
      p_category   = oo.cell(line,'E')
      p_brand      = oo.cell(line,'F')
      p_department = oo.cell(line,'G')
      p_model      = oo.cell(line,'H')
      has_sn = oo.cell(line,'I')
      barcode = oo.cell(line,'J')
      conversion = oo.cell(line,'K')
      uom1 = "PCS"
      price1 = oo.cell(line,'L')
      price2 = oo.cell(line,'M')
      price3 = oo.cell(line,'N')
      price4 = oo.cell(line,'O')
      price5 = oo.cell(line,'P')
      price6 = oo.cell(line,'Q')

      uom2       = oo.cell(line,'R')
      barcode2     = oo.cell(line,'S')
      conversion2 = oo.cell(line,'T')
      price21 = oo.cell(line,'U')
      price22 = oo.cell(line,'V')
      price23 = oo.cell(line,'W')
      price24 = oo.cell(line,'X')
      price25 = oo.cell(line,'Y')
      price26 = oo.cell(line,'Z')

      uom3       = oo.cell(line,'AA')
      barcode3     = oo.cell(line,'AB')
      conversion3 = oo.cell(line,'AC')
      price31 = oo.cell(line,'AD')
      price32 = oo.cell(line,'AE')
      price33 = oo.cell(line,'AF')
      price34 = oo.cell(line,'AG')
      price35 = oo.cell(line,'AH')
      price36 = oo.cell(line,'AI')

      unless code.nil?
        p =  Product.first(:conditions => ["code = ?", code])
        unless p
          p = Product.new
          p.code = code
        end
          p.full_description = desc.strip if desc
          p.short_description = short_desc.strip if short_desc

          p.product_kind_id = 1
          p.product_category = ProductCategory.find_or_create_by_name(p_category) if p_category 
          p.product_brand = ProductBrand.find_or_create_by_name(p_brand) if p_brand 
          p.product_department = ProductDepartment.find_or_create_by_name(p_department) if p_department 
          p.product_model = ProductModel.find_or_create_by_name(p_model) if p_model
          p.save!

          if uom1
            p_uom = ProductUom.find_or_create_by_name(uom1)
            item = p.product_uom_items.first(:conditions => ["product_uom_id = ?", p_uom.id]) if p_uom
            unless item
              item = p.product_uom_items.create(:product_uom_id =>  p_uom.id)
            end
          end
          item.barcode = barcode if barcode
          item.conversion = 1
          item.save!

          price_level1 = PriceLevel.find_or_create_by_name("Norther - WS")
          found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level1.id).first
          unless found
            found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level1.id)
          end
          found.selling_price = price1
          found.save
          
          price_level2 = PriceLevel.find_or_create_by_name("Norther - Dealer")
          found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level2.id).first
          unless found
            found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level2.id)
          end
          found.selling_price = price2
          found.save

          price_level3 = PriceLevel.find_or_create_by_name("Southern - WS")
          found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level3.id).first
          unless found
            found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level3.id)
          end
          found.selling_price = price3
          found.save

          price_level4 = PriceLevel.find_or_create_by_name("Southern - Dealer")
          found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level4.id).first
          unless found
            found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level4.id)
          end
          found.selling_price = price4
          found.save

          price_level5 = PriceLevel.find_or_create_by_name("East Cost - WS")
          found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level5.id).first
          unless found
            found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level5.id)
          end
          found.selling_price = price5
          found.save

          price_level6 = PriceLevel.find_or_create_by_name("East Cost - Dealer")
          found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level6.id).first
          unless found
            found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level6.id)
          end
          found.selling_price = price6
          found.save
          
          #second uom
          if uom2
            p_uom = ProductUom.find_or_create_by_name(uom2)
            item = p.product_uom_items.first(:conditions => ["product_uom_id = ?", p_uom.id]) if p_uom
            unless item
              item = p.product_uom_items.create(:product_uom_id =>  p_uom.id)
            end
            item.barcode = barcode2 if barcode2
            if conversion2
              item.conversion = conversion2
            else
              item.conversion = 2
            end
            item.save!

            found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level1.id).first
            unless found
              found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level1.id)
            end
            found.selling_price = price21
            found.save

            found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level2.id).first
            unless found
              found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level2.id)
            end
            found.selling_price = price22
            found.save

            found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level3.id).first
            unless found
              found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level3.id)
            end
            found.selling_price = price23
            found.save

            found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level4.id).first
            unless found
              found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level4.id)
            end
            found.selling_price = price24
            found.save

            found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level5.id).first
            unless found
              found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level5.id)
            end
            found.selling_price = price25
            found.save

            found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level6.id).first
            unless found
              found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level6.id)
            end
            found.selling_price = price26
            found.save
          end
          
          
          # uom3
          if uom3
            p_uom = ProductUom.find_or_create_by_name(uom3)
            item = p.product_uom_items.first(:conditions => ["product_uom_id = ?", p_uom.id]) if p_uom
            unless item
              item = p.product_uom_items.create(:product_uom_id =>  p_uom.id)
            end
            item.barcode = barcode3 if barcode3
            if conversion3
              item.conversion = conversion3
            else
              item.conversion = 3
            end
            item.save!

            found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level1.id).first
            unless found
              found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level1.id)
            end
            found.selling_price = price31
            found.save

            found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level2.id).first
            unless found
              found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level2.id)
            end
            found.selling_price = price32
            found.save

            found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level3.id).first
            unless found
              found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level3.id)
            end
            found.selling_price = price33
            found.save

            found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level4.id).first
            unless found
              found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level4.id)
            end
            found.selling_price = price34
            found.save

            found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level5.id).first
            unless found
              found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level5.id)
            end
            found.selling_price = price35
            found.save

            found = ProductPricing.where("product_uom_id = ? and product_id = ? and price_level_id = ?", p_uom.id, p.id, price_level6.id).first
            unless found
              found = ProductPricing.create!(:product_id => p.id, :product_uom_id => p_uom.id, :price_level_id => price_level6.id)
            end
            found.selling_price = price36
            found.save
          end
          
       
      end
    end
    "Done"
  end

  def self.import_department
    file = RAILS_ROOT + "/public/product.xls"
    oo = Excel.new(file)
    oo.default_sheet = oo.sheets.first
    2.upto(oo.last_row) do |line|
      code       = oo.cell(line,'A')
      desc       = oo.cell(line,'B')
      short_desc = oo.cell(line,'C')
      #p_kind     = oo.cell(line,'D')
      p_category   = oo.cell(line,'E')
      p_brand      = oo.cell(line,'F')
      p_department = oo.cell(line,'G')
      p_model      = oo.cell(line,'H')

      unless code.nil?
        p = Product.first(:conditions => ["code = ?", code])
        unless p
          
          p.product_category = ProductCategory.find_or_create_by_name(p_category) if p_category
          p.product_brand = ProductBrand.find_or_create_by_name(p_brand) if p_brand
          p.product_department = ProductDepartment.find_or_create_by_name(p_department) if p_department
          p.product_model = ProductModel.find_or_create_by_name(p_model) if p_model
          p.save!
        end
      end
    end
  end

  def self.import_customer
    require 'roo'
    file = RAILS_ROOT + "/public/debtor.xls"
    oo = Excel.new(file)
    oo.default_sheet = oo.sheets.first
    2.upto(oo.last_row) do |line|
      code      = oo.cell(line,'A')
      name      = oo.cell(line,'B')
      add1      = oo.cell(line,'C')
      add2      = oo.cell(line,'D')
      add3      = oo.cell(line,'E')
      add4      = oo.cell(line,'F')
      area      = oo.cell(line,'G')
      phonefax  = oo.cell(line,'H')
      ptc       = oo.cell(line,'I')
      fax       = oo.cell(line,'J')
      term      = oo.cell(line,'K')
      acc_code  = oo.cell(line,'L')
      salesman  = oo.cell(line,'M')
      email = oo.cell(line,'N')

      if name
        customer = Customer.find_or_create_by_code(code)
        customer.name = name

        address = ""
        address << add1 if add1
        address << add2 if add2
        address << add3 if add3
        address << add4 if add4

        customer.address = address
        customer.city = area
        customer.office_contact = phonefax
        customer.fax_number = fax
        customer.term = term
        customer.email = email
        customer.remark = acc_code
        customer.price_level_id = PriceLevel.first.id
        customer.save!
     end
    end
    
    file = RAILS_ROOT + "/public/debtor2.xls"
    oo = Excel.new(file)
    oo.default_sheet = oo.sheets.first
    2.upto(oo.last_row) do |line|
      code      = oo.cell(line,'A')
      name      = oo.cell(line,'B')
      add1      = oo.cell(line,'C')
      add2      = oo.cell(line,'D')
      add3      = oo.cell(line,'E')
      add4      = oo.cell(line,'F')
      area      = oo.cell(line,'G')
      phonefax  = oo.cell(line,'H')
      ptc       = oo.cell(line,'I')
      fax       = oo.cell(line,'J')
      term      = oo.cell(line,'K')
      acc_code  = oo.cell(line,'L')
      salesman  = oo.cell(line,'M')
      email = oo.cell(line,'N')

      if name
        customer = Customer.find_or_create_by_code(code)
        customer.name = name

        address = ""
        address << add1 if add1
        address << add2 if add2
        address << add3 if add3
        address << add4 if add4

        customer.address = address
        customer.city = area
        customer.office_contact = phonefax
        customer.fax_number = fax
        customer.term = term
        customer.email = email
        customer.remark = acc_code
        customer.price_level_id = PriceLevel.first.id
        customer.save!
     end
    end
  end

end
