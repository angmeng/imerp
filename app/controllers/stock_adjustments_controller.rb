class StockAdjustmentsController < ApplicationController
  before_filter :require_user
  # GET /stock_adjustments
  # GET /stock_adjustments.xml

  def index
   @search = StockAdjustment.search(params[:search])
   @stock_adjustments = @search.order('stock_date DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stock_adjustments }
    end
  end

  # GET /stock_adjustments/1
  # GET /stock_adjustments/1.xml
  def show
    @stock_adjustment = StockAdjustment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stock_adjustment }
    end
  end

  

  # GET /stock_adjustments/new
  # GET /stock_adjustments/new.xml
  def new
   @stock_adjustment = StockAdjustment.new
   @stock_adjustment.stock_date = Date.today
   @stock_adjustment.user_id = current_user.id
   @stock_adjustment.save!

    redirect_to edit_stock_adjustment_path(@stock_adjustment)
  end

  # GET /stock_adjustments/1/edit
  def edit
   @search = Product.search(params[:search])
   @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 20)
   @stock_adjustment = StockAdjustment.find(params[:id])
   @stock_adjustment_item = @stock_adjustment.stock_adjustment_items.new

  end
  def update_info
    @stock_adjustment = StockAdjustment.find(params[:id])
     input = Date.parse(params[:stock_adjustment][:stock_date])
         if input > Date.today
           flash[:error] = "Please select valid date "
        else
           @stock_adjustment.update_attributes(params[:stock_adjustment])
          flash[:notice] = "Stock adjustment was successfully updated"
         end
    redirect_to edit_stock_adjustment_path(@stock_adjustment)
  end

  # POST /stock_adjustments
  # POST /stock_adjustments.xml
  def create
     @stock_adjustment = StockAdjustment.new(params[:stock_adjustment])
    #if check_validation
      if @stock_adjustment.save
    redirect_to(edit_stock_adjustment_path(@stock_adjustment), :notice => 'Stock Adjustment was successfully created.')
      else
        render :action => "new"
      end

  end

  # PUT /stock_adjustments/1
  # PUT /stock_adjustments/1.xml
  def update
    @stock_adjustment = StockAdjustment.find(params[:id])

    respond_to do |format|
      if @stock_adjustment.update_attributes(params[:stock_adjustment])
        format.html { redirect_to(@stock_adjustment, :notice => 'Stock adjustment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stock_adjustment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_adjustments/1
  # DELETE /stock_adjustments/1.xml
  def destroy
    @stock_adjustment = StockAdjustment.find(params[:id])
    @stock_adjustment.voided = true
    @stock_adjustment.save!
    flash[:notice] = "Voided Successfully"

    respond_to do |format|
      format.html { redirect_to(stock_adjustments_url) }
      format.xml  { head :ok }
    end
  end

def remove_item
    item = StockAdjustmentItem.find(params[:id])
    item.destroy
    flash[:notice] = "Stock adjustment was successfully removed"
    redirect_to edit_stock_adjustment_path(item.stock_adjustment)
  end

def update_item
  @stock_adjustment = StockAdjustment.find(params[:id])
   @items = @stock_adjustment.stock_adjustment_items
  
    if params[:commit] == "Update items"
       errors = @stock_adjustment.update_item(params[:item])
       if errors.empty?
            flash[:notice] = "Stock Adjustment Item was successfully updated"
       else
          flash[:error] = errors
       end
      
    elsif params[:commit] == "Remove items"
       @stock_adjustment.remove_item(params[:item])
       flash[:notice] = "Stock Adjustment Item was successfully removed"
    end
    redirect_to edit_stock_adjustment_path(@stock_adjustment)
  end
 

  def add_item
    @stock_adjustment = StockAdjustment.find(params[:id])
    @stock_adjustment.add_item(params[:item])
    
     flash[:notice] = "Stock Adjustment Item was successfully Added"
    
   if params[:commit] == "Add and Return"
    redirect_to edit_stock_adjustment_path(@stock_adjustment)
    elsif params[:commit] == "Add and Continue"
    redirect_to item_new_page_stock_adjustment_path(@stock_adjustment)
  end
  end

  def add_auto_complete_stock
    @stock_adjustment = StockAdjustment.find(params[:id])
       @stock_adjustment.add_autocomplete_item(params[:stock_adjustment])
        flash[:notice] = "Stock Adjustment Item was successfully Added"
        
    redirect_to item_new_page_stock_adjustment_path(@stock_adjustment)
  end

   def settle
    @stock_adjustment = StockAdjustment.find(params[:id])
    if params[:status_id].to_i == 1
       pass = @stock_adjustment.check_settle
       if pass
         flash[:notice] = "Stock Adjustment was successfully settled"
       else
         flash[:error] = "Stock Adjustment unsucessfully settled. Please fill the stock adjustment item"
       end
    elsif params[:status_id].to_i == 2
       @stock_adjustment.settled = false
       @stock_adjustment.save!
    end
    redirect_to edit_stock_adjustment_path(@stock_adjustment)
  end

   def unsettled
    @stock_adjustments = StockAdjustment.unsettled.paginate(:page => params[:page], :per_page => 50)
  end

   def post_quantity
    @stock_adjustment = StockAdjustment.find(params[:id])
    if @stock_adjustment.post_quantity
      flash[:notice] = "Stock Adjustment was successfully post quantity"
    else
      flash[:error] = "Stock Adjustment is already posted"
    end
    redirect_to edit_stock_adjustment_path(@stock_adjustment)
  end

  def show_popup
     @product = Product.find(params[:id])
     @result = @product.collect_virtual_quantity
    render :layout => false

 end


  def preview
    @stock_adjustment = StockAdjustment.find(params[:id])
    @settings = Setting.all
    render :layout => false
  end

  def item_new_page
   @search = Product.search(params[:search])
   @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 20)
   @stock_adjustment = StockAdjustment.find(params[:id])
   @stock_adjustment_item = @stock_adjustment.stock_adjustment_items.new
  end

  def removed_item
    @stock_adjustment = StockAdjustment.find(params[:id])
     params[:item] ||= []
    if params[:item].any?
     @stock_adjustment.remove_item(params[:item])
      flash[:notice] = "Stock Adjustment was successfully removed"
   else
      flash[:error] = "must choose at least one item"
    end
     
   redirect_to item_new_page_stock_adjustment_path(@stock_adjustment)
 end


end

