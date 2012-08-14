class ProductLocationsController < ApplicationController
  before_filter :require_user
  # GET /product_locations
  # GET /product_locations.xml
  def index
    @product_locations = ProductLocation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_locations }
    end
  end

  # GET /product_locations/1
  # GET /product_locations/1.xml
  def show
    @product_location = ProductLocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_location }
    end
  end

  # GET /product_locations/new
  # GET /product_locations/new.xml
  def new
    @product_location = ProductLocation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_location }
    end
  end

  # GET /product_locations/1/edit
  def edit
    @product_location = ProductLocation.find(params[:id])
    show_racks
  end

  # POST /product_locations
  # POST /product_locations.xml
  def create
    @product_location = ProductLocation.new(params[:product_location])

    respond_to do |format|
      if @product_location.save
        format.html { redirect_to(edit_product_location_path(@product_location), :notice => 'Product location was successfully created.') }
        format.xml  { render :xml => @product_location, :status => :created, :location => @product_location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /product_locations/1
  # PUT /product_locations/1.xml
  def update
    @product_location = ProductLocation.find(params[:id])

    respond_to do |format|
      if @product_location.update_attributes(params[:product_location])
        format.html { redirect_to(edit_product_location_path(@product_location), :notice => 'Product location was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { 
          show_racks
          render :action => "edit" 
          }
        format.xml  { render :xml => @product_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /product_locations/1
  # DELETE /product_locations/1.xml
  def destroy
    @product_location = ProductLocation.find(params[:id])
    @product_location.disabled = true
    @product_location.save!
    flash[:error] = "Location has been disabled"

    respond_to do |format|
      format.html { redirect_to(product_locations_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def show_racks
    @product_location = ProductLocation.find(params[:id])
    @racks = @product_location.product_racks.all.uniq.paginate(:page => params[:page], :per_page => 10)
    @product_rack = ProductRack.new 
  end
  
end
