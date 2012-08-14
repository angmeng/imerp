class ProductRacksController < ApplicationController
  before_filter :require_user
  # GET /product_racks
  # GET /product_racks.xml


  def index
   @search = ProductRack.search(params[:search])
   @product_racks = @search.all.uniq.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /product_racks/1
  # GET /product_racks/1.xml
  def show
    find_rack

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_rack }
    end
  end

  # GET /product_racks/new
  # GET /product_racks/new.xml
  def new
    @product_rack = ProductRack.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_rack }
    end
  end

  # GET /product_racks/1/edit
  def edit
   #@search = Product.search(params[:search])
   #@products = @search.all.uniq.paginate(:page => params[:page], :per_page => 20)
    find_rack
    find_location
    show_stocks

  end

  def edit_rack
     find_rack
    find_location

#     @product_rack.update_attributes(params[:product_rack])
#     flash[:notice] = "Product rack was successfully updated"
#
   
        
  end

  # POST /product_racks
  # POST /product_racks.xml
  def create
    @product_rack = ProductRack.new(params[:product_rack])

    respond_to do |format|
      if @product_rack.save
        format.html {
          redirect_to(edit_product_location_path(@product_rack.product_location), :notice => 'Product rack was successfully created.')
          }
        format.xml  { render :xml => @product_rack, :status => :created, :location => @product_rack }
      else
        format.html {
          @product_location = ProductLocation.find(params[:product_rack][:product_location_id].to_i)
          @racks = @product_location.product_racks
          render :template => 'product_locations/show_racks'
        }
        format.xml  { render :xml => @product_rack.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /product_racks/1
  # PUT /product_racks/1.xml
  def update
    find_rack

    respond_to do |format|
      if @product_rack.update_attributes(params[:product_rack])
        format.html { redirect_to(edit_product_location_path(@product_rack.product_location), :notice => 'Product rack was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html {
          show_stocks
          find_location
          render :action => "edit"
          }
        format.xml  { render :xml => @product_rack.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /product_racks/1
  # DELETE /product_racks/1.xml
  def destroy
    find_rack
    if @product_rack.verify_destroy
      flash[:notice] = "Product rack was successfully removed "
    else
      flash[:error] = "Rack cannot be removed"
    end

    redirect_to(edit_product_location_path(@product_rack.product_location_id))
  end

  def add_stocks
    find_rack
    if params[:product_ids]
      @products = Product.find(params[:product_ids])
      @products.each do |product|
     @product_rack.stock_locations.create!(:product_id => product.id)
      end
      flash[:notice] = "Stock was successfully added"
    else
      flash[:error] = "Select at least one item"
    end
    if params[:commit].include?("Return")
      redirect_to(edit_product_rack_path(@product_rack) + "#new_stocks")
    else
      redirect_to new_stocks_product_rack_path(@product_rack)
    end
  end

  def remove_stocks
    find_rack
    if params[:product_ids]
      @products = Product.find(params[:product_ids])
      @products.each do |product|
        @product_rack.stock_locations.first(:conditions => ['product_id = ?', product.id]).destroy
      end
      flash[:notice] = "Stock was successfully removed"
    else
      flash[:error] = "Select at least one item"
    end

    redirect_to edit_product_rack_path(@product_rack)
  end

  def new_stocks
    find_rack
    show_stocks
    @search = Product.active_normal_products.search(params[:search])
    @products = (Product.filter(@stocks, @search.all)).paginate(:page => params[:page], :per_page => 20)
    #@products = @products.paginate(:page => params[:page], :per_page => 20)
  end

  def add_item
    @product_rack = ProductRack.find(params[:id])
    @product_rack.add_item(params[:item])
    flash[:notice] = "Product rack item was successfully added "
    if params[:commit] == "Add Item"
      redirect_to edit_product_rack_path(@product_rack)
    elsif params[:commit] == "Add Item and continue add"
       redirect_to item_new_page_product_rack_path(@product_rack)
  end

  end

  def add_auto_complete_item
    @product_rack = ProductRack.find(params[:id])
    @product_rack.add_autocomplete_item(params[:product_rack])
       flash[:notice] = "Product rack item was successfully Added"
       redirect_to item_new_page_product_rack_path(@product_rack)
  end

  def item_new_page
    @search = Product.search(params[:search])
    @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 20)
    find_rack
    find_location
    show_stocks
  end

 def delete_item
   @product_rack = ProductRack.find(params[:id])
     @product_rack.remove_item(params[:item])
       flash[:notice] = "Product rack item was successfully Removed"
   redirect_to edit_product_rack_path(@product_rack)
 end

 def removed_item
   @product_rack = ProductRack.find(params[:id])
   @product_rack.remove_item(params[:item])
   flash[:notice] = "Product rack item was successfully Removed"
   redirect_to item_new_page_product_rack_path(@product_rack)
 end

  def add_all
    @product_rack = ProductRack.find(params[:id])
    Product.all.each do |p|
      found = @product_rack.stock_locations.first(:conditions => ["product_id = ?", p.id])
      if found
        found.product.product_uom_items.all.each do |u|
          unless found.stock_counts.where("product_uom_item_id = ? and product_uom_id = ? and product_id = ?", u.id, u.product_uom_id, u.product_id).first
            found.stock_counts.create!(:product_uom_item_id => u.id, :product_uom_id => u.product_uom_id, :product_id => u.product_id)
          end
        end
      else
        i = @product_rack.stock_locations.new
        i.product_id = p.id
        #i.product_uom_id = content[:product_uom_id]
        i.save!
      end
    end
    flash[:notice] = "All products was successfully added to the location"
    redirect_to edit_product_rack_path(@product_rack)
  end

  def add_uoms
    @product_rack = ProductRack.find(params[:id])

    @product_rack.stock_locations.each do |s|
      s.product.product_uom_items.all.each do |u|
        unless s.product.product_uom_items.where("product_uom_id = ? and product_id = ?", u.product_uom_id, u.product_id).first
          s.stock_counts.create!(:product_uom_item_id => u.id, :product_uom_id => u.product_uom_id, :product_id => u.product_id)
        end
      end
    end
    flash[:notice] = "All product uoms was successfully added to the location"
    redirect_to edit_product_rack_path(@product_rack)
  end

  def new_rack
    @product_rack = ProductRack.new
    @product_location = ProductLocation.find(params[:id])rescue nil
    render :layout => false
  end



  private

  def find_rack
    @product_rack = ProductRack.find(params[:id])
  end

  def find_location
    @product_location = @product_rack.product_location
  end

  def show_stocks
    @stocks = @product_rack.products.includes([:product_kind, :product_department, :product_brand, :product_category, :product_model]).paginate(:page => params[:page], :per_page => 20)
  end



end
