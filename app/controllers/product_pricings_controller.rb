class ProductPricingsController < ApplicationController
  before_filter :require_user
  # GET /product_pricings
  # GET /product_pricings.xml
  def index
    @product_pricings = ProductPricing.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_pricings }
    end
  end

  # GET /product_pricings/1
  # GET /product_pricings/1.xml
  def show
    @product_pricing = ProductPricing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_pricing }
    end
  end

  # GET /product_pricings/new
  # GET /product_pricings/new.xml
  def new
    @product_pricing = ProductPricing.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_pricing }
    end
  end

  # GET /product_pricings/1/edit
  def edit
    @product_pricing = ProductPricing.find(params[:id])
  end

  # POST /product_pricings
  # POST /product_pricings.xml
  def create
    
    @product_pricing = ProductPricing.new(params[:product_pricing])
    

    respond_to do |format|
      if @product_pricing.save
        format.html { 
          redirect_to(show_pricings_product_uom_path(@product_uom), :notice => 'Product pricing was successfully created.') 
          }
        format.xml  { render :xml => @product_pricing, :status => :created, :location => @product_pricing }
      else
        format.html { 
          @product_uom = ProductUom.find(params[:product_pricing][:product_uom_id].to_i)
          @pricings = @product_uom.product_pricings
          @product = @product_uom.product
          render :template => "/product_uoms/show_pricings"  
          }
        format.xml  { render :xml => @product_pricing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /product_pricings/1
  # PUT /product_pricings/1.xml
  def update
    @product_pricing = ProductPricing.find(params[:id])

    respond_to do |format|
      if @product_pricing.update_attributes(params[:product_pricing])
        format.html { redirect_to(@product_pricing, :notice => 'Product pricing was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_pricing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /product_pricings/1
  # DELETE /product_pricings/1.xml
  def destroy
    @product_pricing = ProductPricing.find(params[:id])
    uom = @product_pricing.product_uom
    @product_pricing.destroy
    flash[:notice] = "Successfully removed"
    respond_to do |format|
      format.html { redirect_to(show_pricing_product_uom_path(uom)) }
      format.xml  { head :ok }
    end
  end
end
