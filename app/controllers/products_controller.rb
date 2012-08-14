class ProductsController < ApplicationController
  before_filter :require_user
  #autocomplete :product_brand, :name

  # GET /products
  # GET /products.xml
  def index
    @search = Product.active.search(params[:search])
    @products = @search.all.paginate(:page => params[:page], :per_page => 20)
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @products }
      format.json { render :json => @products.map(&:attributes) }
    end
  end

  def query
    @products = Product.where("name LIKE ?", "%#{params[:q]}%")
      
    respond_to do |format|
      format.html
      format.xml  { render :xml => @products }
      format.json { render :json => @products.map(&:attributes)}
    end
  end

  

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new
     

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    @uoms = @product.product_uom_items.order("conversion")
  
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { 
          if params[:commit].include?("continue")
            redirect_to(new_product_path, :notice => 'Product was successfully created.')
          else 
            redirect_to(edit_product_path(@product), :notice => 'Product was successfully created.') 
          end
          }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
     @product = Product.find(params[:id])
   if @product.is_mixed?
       if @product.product_kind_id == params[:product][:product_kind_id].to_i
           flash[:notice] = "Product was successfully updated"
           @product.update_attributes(params[:product])
       else
          if @product.mixed_items.any?
              flash[:error] = "Product was unsuccessfully updated. Please delete mixed item list to update type of product "
          else
              flash[:notice] = "Product was successfully updated"
              @product.update_attributes(params[:product])
          end
       end
    else
         flash[:notice] = "Product was successfully updated"
         @product.update_attributes(params[:product])
      
    end
      redirect_to edit_product_path(@product)
  end

  

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.set_destroy
    flash[:notice] = "Successfully disabled the product"
    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end
  
  def add_uoms
    @product = Product.find(params[:id])
     params[:product_uom_ids] ||= []
    if params[:product_uom_ids].any?
      uoms = ProductUom.find(params[:product_uom_ids])
    uoms.each do |u|
      @product.product_uom_items.create!(:product_uom_id => u.id) unless @product.product_uom_items.first(:conditions => ["product_uom_id = ?", u.id])
    end
    flash[:notice] = "successfully add Uom "
    else
      flash[:error] = "must choose at least one item"
    end
    
    redirect_to(edit_product_path(@product) + "#pricing") 
  end

  
  def update_uoms
    @product = Product.find(params[:id])
    check_default = 0
    params[:uom] ||= []
    params[:uom].each do |item_id, content|
     item = ProductUomItem.find(item_id)
      item.barcode = content[:barcode]
      item.conversion = content[:conversion]
      item.fixed_cost = content[:fixed_cost]
      item.minimum_selling_price = content[:minimum_selling_price]
      if content[:selected]
        item.default_uom = true
      else
        item.default_uom = false
      end
       if content[:conversion].to_i == 1
        check_default += 1
      end
      item.save!
    end
    if check_default == 0
      flash[:error] = "You need to set one item to be the default conversion with quantity 1"
    elsif check_default > 1
      flash[:error] = "You only can set one item to be the default conversion with quantity 1"
    else
      flash[:notice] = "Update Completed"
    end
    
    redirect_to(edit_product_path(@product) + "#pricing") 
  end

  def virtual_movement
    product_ids = params[:product][:product_tokens].split(",") unless params[:product][:product_tokens].blank? if params[:product]
    if product_ids
       @search = ProductVirtualMovement.search(params[:search])
       @search.product_id_in = product_ids
    else
       @search = ProductVirtualMovement.search(params[:search])
    end
    @result = @search.order('movement_date DESC').all
    @product_selection = Product.active.all.map {|p| [p.code, p.id]}
    @uom_selection     = ProductUom.all.map {|u| [u.name, u.id]}
  end

  def product_movement
    product_ids = params[:product][:product_tokens].split(",") unless params[:product][:product_tokens].blank? if params[:product]
    if product_ids
      @search = ProductMovement.search(params[:search])
      @search.product_id_in = product_ids
    else
      @search = ProductMovement.search(params[:search])
    end
    @result = @search.order('movement_date DESC').all
    @product_selection = Product.active.all.map {|p| [p.code, p.id]}
    @uom_selection     = ProductUom.all.map {|u| [u.name, u.id]}
  end

  def show_popup
    @uom_item = ProductUomItem.find(params[:id])
    @result = @uom_item.collect_stocks
    render :layout => false
  end

  def show_onhand
    @uom_item = ProductUomItem.find(params[:id])
    @result = @uom_item.collect_stocks
    render :layout => false
  end


  def add_location
    @product = Product.find(params[:id])
    @stock_location = @product.stock_locations
    @show_rack = ProductRack.all
  end

  def remove_rack
    @product = Product.find(params[:id])
    @product.remove_product(params[:item])
    flash[:notice] = "Product Rack was successfully removed"
    redirect_to add_location_product_path(@product)

  end

  def add_product
    @product = Product.find(params[:id])
    @product.add_item(params[:item])
    flash[:notice] = "Product Rack was successfully added"
    redirect_to add_location_product_path(@product)
  end

  def auto_complete_product
    @product = Product.find(params[:id])
    @product.autocomplete_item(params[:product])
    flash[:notice] = "Product Movement"
    
  end

  def new_brand
    @product = Product.find(params[:id])
    render :layout => false
  end

  def mixed_product
    @product_uom_item = ProductUomItem.find(params[:id])
    @product = @product_uom_item.product
  end

 
  
end
