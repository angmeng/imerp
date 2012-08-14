class StockLocationsController < ApplicationController
  before_filter :require_user
  # GET /stock_locations
  # GET /stock_locations.xml
  def index
    @stock_locations = StockLocation.all(:joins => [:product, {:product_rack => :product_location}])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stock_locations }
    end
  end

  # GET /stock_locations/1
  # GET /stock_locations/1.xml
  def show
    @stock_location = StockLocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stock_location }
    end
  end

  # GET /stock_locations/new
  # GET /stock_locations/new.xml
  def new
    @stock_location = StockLocation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stock_location }
    end
  end

  # GET /stock_locations/1/edit
  def edit
    @stock_location = StockLocation.find(params[:id])
  end

  # POST /stock_locations
  # POST /stock_locations.xml
  def create
    @stock_location = StockLocation.new(params[:stock_location])

    respond_to do |format|
      if @stock_location.save
        format.html { redirect_to(edit_stock_location_path(@stock_location), :notice => 'Stock location was successfully created.') }
        format.xml  { render :xml => @stock_location, :status => :created, :location => @stock_location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stock_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stock_locations/1
  # PUT /stock_locations/1.xml
  def update
    @stock_location = StockLocation.find(params[:id])

    respond_to do |format|
      if @stock_location.update_attributes(params[:stock_location])
        format.html { redirect_to(edit_stock_location_path(@stock_location), :notice => 'Stock location was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stock_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_locations/1
  # DELETE /stock_locations/1.xml
  def destroy
    @stock_location = StockLocation.find(params[:id])
    @stock_location.destroy

    respond_to do |format|
      format.html { redirect_to(stock_locations_url) }
      format.xml  { head :ok }
    end
  end
  
  def show_opening_balance
    @product_rack = ProductRack.find(params[:id])
    @product = Product.find(params[:product_id])
    @stock_location = @product_rack.stock_locations.first(:conditions => ["product_id = ?", @product.id])
    @stock_counts = @stock_location.stock_counts
  end
  
  def update_balance
    @stock_location = StockLocation.find(params[:id])
    update_each_balance(params[:stock_count])
    flash[:notice] = "Stock location was successfully updated"
    redirect_to(show_opening_balance_stock_location_path(@stock_location.product_rack_id, :product_id => @stock_location.product_id))
    #redirect_to(edit_product_rack_path(@stock_location.product_rack))
  end
  
  private
  
  def update_each_balance(balances)
    balances.each {|item_id, content|
      bal = StockCount.find(item_id.to_i)
     
      unless content[:opening_balance].blank? 
        bal.opening_balance = content[:opening_balance].to_f
        bal.save!
      end if bal
    }
    
  end
  
end
