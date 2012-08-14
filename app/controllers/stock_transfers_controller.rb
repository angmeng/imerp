class StockTransfersController < ApplicationController
  before_filter :require_user
  # GET /stock_transfers
  # GET /stock_transfers.xml
  
  def index
   @search = StockTransfer.search(params[:search])
   @stock_transfers = @search.order('stock_transfer_date DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stock_transfers }
    end
  end

  # GET /stock_transfers/1
  # GET /stock_transfers/1.xml
  def show
    @stock_transfer = StockTransfer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stock_transfer }
    end
  end
  def update_info
   @stock_transfer = StockTransfer.find(params[:id])
   input = Date.parse(params[:stock_transfer][:stock_transfer_date])
         if input > Date.today
           flash[:error] = "Please select valid date "
        else
         @stock_transfer.update_attributes(params[:stock_transfer])
          flash[:notice] = "Stock Transfer was successfully updated"
         end
    redirect_to edit_stock_transfer_path(@stock_transfer)
  end

  # GET /stock_transfers/new
  # GET /stock_transfers/new.xml
  def new
    @stock_transfer = StockTransfer.new
    @stock_transfer.stock_transfer_date = Date.today
    @stock_transfer.user_id = current_user.id
    @stock_transfer.save!
    redirect_to edit_stock_transfer_path(@stock_transfer)
  end

  # GET /stock_transfers/1/edit
  def edit
   @search = Product.search(params[:search])
   @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 20)
   @stock_transfer = StockTransfer.find(params[:id])
   @stock_transfer_item = @stock_transfer.stock_transfer_items.new
    
  end

  # POST /stock_transfers
  # POST /stock_transfers.xml
  def create
    @stock_transfer = StockTransfer.new(params[:stock_transfer])
      if @stock_transfer.save
    redirect_to(edit_stock_transfer_path(@stock_transfer), :notice => 'Stock Transfer was successfully created.')
      else
        render :action => "new"
      end
    end
  

  # PUT /stock_transfers/1
  # PUT /stock_transfers/1.xml
  def update
    @stock_transfer = StockTransfer.find(params[:id])

    respond_to do |format|
      if @stock_transfer.update_attributes(params[:stock_transfer])
        format.html { redirect_to(@stock_transfer, :notice => 'Stock transfer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stock_transfer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_transfers/1
  # DELETE /stock_transfers/1.xml
  def destroy
    @stock_transfer = StockTransfer.find(params[:id])
    @stock_transfer.voided = true
    @stock_transfer.save!
    flash[:notice] = "Voided Successfully"

    respond_to do |format|
      format.html { redirect_to(stock_transfers_url) }
      format.xml  { head :ok }
    end
  end

def remove_item
    item = StockTransferItem.find(params[:id])
    item.destroy
    flash[:notice] = "Stock Transfer Item was successfully removed"
    redirect_to edit_stock_transfer_path(item.stock_transfer)
  end

def update_item
  @stock_transfer = StockTransfer.find(params[:id])
   @items = @stock_transfer.stock_transfer_items

    if params[:commit] == "Update items"
       errors = @stock_transfer.update_item(params[:item])
       if errors.empty?
           flash[:notice] = "Stock Transfer Item was successfully updated"
       else
          flash[:error] = errors
       end
       
    elsif params[:commit] == "Remove items"
       @stock_transfer.remove_item(params[:item])
       flash[:notice] = "Stock Transfer Item was successfully removed"
    end
    redirect_to edit_stock_transfer_path(@stock_transfer)
  end


  def add_item
    @stock_transfer = StockTransfer.find(params[:id])
    @stock_transfer.add_item(params[:item])
    
      flash[:notice] = "Stock Transfer was successfully added"
    
   if params[:commit] == "Add and Return"
    redirect_to edit_stock_transfer_path(@stock_transfer)
    elsif params[:commit] == "Add and Continue"
     redirect_to item_new_page_stock_transfer_path(@stock_transfer)
  end
  end

  def add_auto_complete_product
   @stock_transfer = StockTransfer.find(params[:id])
   @stock_transfer.add_autocomplete_item(params[:stock_transfer])
      flash[:notice] = "Stock Transfer was successfully added"
       
    redirect_to item_new_page_stock_transfer_path(@stock_transfer)
  end

    def settle
    @stock_transfer = StockTransfer.find(params[:id])
    if params[:status_id].to_i == 1
       pass = @stock_transfer.check_settle
       if pass
         flash[:notice] = "Stock Transfer was successfully settled"
       else
         flash[:error] = "Stock transfer unsucessfully settled. Please fill the stock transfer item"
       end
    elsif params[:status_id].to_i == 2
       @stock_transfer.settled = false
       @stock_transfer.save!
    end
    redirect_to edit_stock_transfer_path(@stock_transfer)
  end


   def unsettled
    @stock_transfers = StockTransfer.unsettled.paginate(:page => params[:page], :per_page => 50)
  end

   def post_quantity
    @stock_transfer = StockTransfer.find(params[:id])
    if @stock_transfer.post_quantity
      flash[:notice] = "Stock Transfer was successfully post quantity"
    else
      flash[:error] = "Stock Transfer is already posted"
    end
    redirect_to edit_stock_transfer_path(@stock_transfer)
  end

  def preview
    @stock_transfer = StockTransfer.find(params[:id])
    @settings = Setting.all
    render :layout => false
  end
def show_popup
     @product = Product.find(params[:id])
     @result = @product.collect_virtual_quantity
    render :layout => false

 end
 def item_new_page
  @search = Product.search(params[:search])
   @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 20)
   @stock_transfer = StockTransfer.find(params[:id])
   @stock_transfer_item = @stock_transfer.stock_transfer_items.new
  end

  def removed_item
     @stock_transfer = StockTransfer.find(params[:id])
      params[:item] ||= []
    if params[:item].any?
     @stock_transfer.remove_item(params[:item])
      flash[:notice] = "Stock Transfer was successfully removed"
   else
      flash[:error] = "must choose at least one item"
    end
    redirect_to item_new_page_stock_transfer_path(@stock_transfer)
 end

  end