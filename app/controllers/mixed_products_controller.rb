class MixedProductsController < ApplicationController
  before_filter :require_user
  # GET /mixed_products
  # GET /mixed_products.xml
  def index
    @mixed_products = MixedProduct.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mixed_products }
      format.json { render :json => @mixed_products.map(&:attributes) }
    end
  end

  # GET /mixed_products/1
  # GET /mixed_products/1.xml
  def show
    @mixed_product = MixedProduct.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mixed_product }
    end
  end

  # GET /mixed_products/new
  # GET /mixed_products/new.xml
  def new
    @mixed_product = MixedProduct.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mixed_product }
    end
  end

  # GET /mixed_products/1/edit
  def edit
    @mixed_product = MixedProduct.find(params[:id])
  end

  # POST /mixed_products
  # POST /mixed_products.xml
  def create
    @mixed_product = MixedProduct.new(params[:mixed_product])

    respond_to do |format|
      if @mixed_product.save
        format.html { redirect_to(@mixed_product, :notice => 'Mixed product was successfully created.') }
        format.xml  { render :xml => @mixed_product, :status => :created, :location => @mixed_product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mixed_product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /mixed_products/1
  # PUT /mixed_products/1.xml
  def update
    @mixed_product = MixedProduct.find(params[:id])

    respond_to do |format|
      if @mixed_product.update_attributes(params[:mixed_product])
        format.html { redirect_to(@mixed_product, :notice => 'Mixed product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mixed_product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mixed_products/1
  # DELETE /mixed_products/1.xml
  def destroy
    @mixed_product = MixedProduct.find(params[:id])
    @product = @mixed_product.parent
    @mixed_product.destroy
    flash[:notice] = "Successfully removed"
  end
  
  def show_products
    @product_uom_item = ProductUomItem.find(params[:id])
    @product = @product_uom_item.product
    @search = Product.active_normal_products.search(params[:search])
    @products = @search.all.paginate(:page => params[:page], :per_page => 20)
  end
  
  def add_products
    @product_uom_item = ProductUomItem.find(params[:id])
    @product = @product_uom_item.product
    add_mixed_items

    flash[:notice] = "Operation Completed"
    if params[:commit].include?("Return")
      redirect_to(mixed_product_product_path(@product))
    else
      redirect_to(show_products_mixed_product_path(@product))
    end
    
  end
  
  def update_quantity
    @product_uom_item = ProductUomItem.find(params[:id])
    @product = @product_uom_item.product
    
    update_each_quantity(params[:mixed_product])
    flash[:notice] = "Operation Completed"
    #redirect_to(show_products_mixed_product_path(@product))
  end
  
  
  private
  
  def find_product
    @product = Product.find(params[:id])
  end
   def find_uom
    @product_uom = ProductUom.find(params[:id])
  end
  
  def update_each_quantity(quantities)
    quantities.each {|pro_id, content|
      pro = @product.mixed_items.find(pro_id.to_i)
     
      unless content[:quantity].blank? 
        pro.quantity = content[:quantity].to_f
        pro.product_uom_id = content[:product_uom_id].to_i
        pro.save!
      end if pro
    }
  end
  
  def add_mixed_items
    if params[:product_ids].any?
      products = Product.find(params[:product_ids])
      products.each do |p|
        unless MixedProduct.where("product_id = ? and parent_id=? and parent_uom_id = ?", p.id ,@product_uom_item.product_id,@product_uom_item.product_uom_id).first
          MixedProduct.create(:product_id => p.id, :parent_id => @product_uom_item.product_id, :parent_uom_id => @product_uom_item.product_uom_id)
        end
      end
    end
  end
end
