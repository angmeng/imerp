class ProductUomsController < ApplicationController
  before_filter :require_user
  # GET /product_uoms
  # GET /product_uoms.xml
  def index
    @product_uoms = ProductUom.all.uniq.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_uoms }
    end
  end

  # GET /product_uoms/1
  # GET /product_uoms/1.xml
  def show
    @product_uom = ProductUom.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_uom }
    end
  end

  # GET /product_uoms/new
  # GET /product_uoms/new.xml
  def new
    @product_uom = ProductUom.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_uom }
    end
  end

  # GET /product_uoms/1/edit
  def edit
    @product_uom = ProductUom.find(params[:id])
  end

  # POST /product_uoms
  # POST /product_uoms.xml
  def create
    @product_uom = ProductUom.new(params[:product_uom])
 
    if @product_uom.save
      flash[:notice] = "Product Uom was successfully created"
      redirect_to edit_product_uom_path(@product_uom)
    else
      flash[:notice] = "product Uom was successfully created"
      render :action => "new"
    end   
  end

  # PUT /product_uoms/1
  # PUT /product_uoms/1.xml
  def update
    @product_uom = ProductUom.find(params[:id])

    respond_to do |format|
      if @product_uom.update_attributes(params[:product_uom])
        format.html { 
          flash[:notice] = 'Product uom was successfully updated.'
          redirect_to edit_product_uom_path(@product_uom) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_uom.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @product_uom = ProductUom.find(params[:id])
    @product_uom.destroy
    flash[:notice] = "Product uom was successfully removed"
    redirect_to product_uoms_path
  end
  
  def remove_item
    item = ProductUomItem.find(params[:id])
    product = item.product
    item.destroy
    flash[:notice] = "Product uom item was successfully deleted"
    redirect_to (edit_product_path(product) + "#pricing")
  end
  
  def show_pricings
    @item = ProductUomItem.find(params[:id])
    @product_uom = @item.product_uom 
    @product = @item.product
    @pricings = @item.product_pricings.joins(:price_level)
    @min_uom = @product.collect_minimum_uom(@item)
  end
  
  def update_pricings
    @item = ProductUomItem.find(params[:id])
    update_each_pricing(params[:pricing])
    flash[:notice] = "Update Pricing was successfully Completed"
    redirect_to(show_pricings_product_uom_path(@item))
  end
  
  private
  
  def update_each_pricing(pricings)
    pricings.each {|price_id, content|
      pricing = ProductPricing.find(price_id.to_i)
     
      unless content[:selling_price].blank? 
        pricing.selling_price = content[:selling_price].to_f
        pricing.product_uom_id = @item.product_uom_id
        pricing.product_id = @item.product_id
        pricing.save!
      end if pricing
    }
    
  end
  
end
