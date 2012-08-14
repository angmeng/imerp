class StockDisposalsController < ApplicationController
  before_filter :require_user
  # GET /stock_disposals
  # GET /stock_disposals.xml

  def index
   @search = StockDisposal.search(params[:search])
   @stock_disposals = @search.order('stock_disposal_date DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stock_disposals }
    end
  end

  # GET /stock_disposals/1
  # GET /stock_disposals/1.xml
  def show
    @stock_disposal = StockDisposal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stock_disposal }
    end
  end
  def update_info
    @stock_disposal = StockDisposal.find(params[:id])
    input = Date.parse(params[:stock_disposal][:stock_disposal_date])
         if input > Date.today
           flash[:error] = "Please select valid date "
        else
          @stock_disposal.update_attributes(params[:stock_disposal])
          flash[:notice] = "Stock Disposal was successfully"
        end
    redirect_to edit_stock_disposal_path(@stock_disposal)
  end

  # GET /stock_disposals/new
  # GET /stock_disposals/new.xml
  def new
    @stock_disposal = StockDisposal.new
    @stock_disposal.stock_disposal_date = Date.today
    @stock_disposal.user_id = current_user.id
    @stock_disposal.save!
    redirect_to edit_stock_disposal_path(@stock_disposal)

  end

  # GET /stock_disposals/1/edit
  def edit
   @search = Product.search(params[:search])
   @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 20)
   @stock_disposal = StockDisposal.find(params[:id])
   @stock_disposal_item = @stock_disposal.stock_disposal_items.new

  end

  # POST /stock_disposals
  # POST /stock_disposals.xml
  def create
    @stock_disposal = StockDisposal.new(params[:stock_disposal])
      if @stock_disposal.save
    redirect_to(edit_stock_disposal_path(@stock_disposal), :notice => 'Stock disposal was successfully created.')
      else
        render :action => "new"
      end
    end

  # PUT /stock_disposals/1
  # PUT /stock_disposals/1.xml
  def update
    @stock_disposal = StockDisposal.find(params[:id])

    respond_to do |format|
      if @stock_disposal.update_attributes(params[:stock_disposal])
        format.html { redirect_to(@stock_disposal, :notice => 'Stock disposal was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stock_disposal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_disposals/1
  # DELETE /stock_disposals/1.xml
  def destroy
    @stock_disposal = StockDisposal.find(params[:id])
    @stock_disposal.voided = true
    @stock_disposal.save!
    flash[:notice] = "Voided Successfully"

    respond_to do |format|
      format.html { redirect_to(stock_disposals_url) }
      format.xml  { head :ok }
    end
  end

  def add_item
    @stock_disposal = StockDisposal.find(params[:id])
   @stock_disposal.add_item(params[:item])
   
      flash[:notice] = "Stock Disposal Item was successfully added"
    
    if params[:commit] == "Add and Return"
    redirect_to edit_stock_disposal_path(@stock_disposal)
    elsif params[:commit] == "Add and Continue"
     redirect_to item_new_page_stock_disposal_path(@stock_disposal)
  end
  end

  def add_auto_complete_product
     @stock_disposal = StockDisposal.find(params[:id])
      @stock_disposal.add_autocomplete_item(params[:stock_disposal])
        flash[:notice] = "Stock Disposal Item was successfully added"
        
    redirect_to item_new_page_stock_disposal_path(@stock_disposal)
  end

  def remove_item
    item = StockDisposalItem.find(params[:id])
    item.destroy
    flash[:notice] = "Stock Disposal Item was successfully removed"
    redirect_to edit_stock_disposal_path(item.stock_disposal)
  end

def update_item
  @stock_disposal = StockDisposal.find(params[:id])
   @items = @stock_disposal.stock_disposal_items

    if params[:commit] == "Update items"
       errors = @stock_disposal.update_item(params[:item])
        if errors.empty?
           flash[:notice] = "Stock Disposal Item was successfully updated"
       else
          flash[:error] = errors
       end
      
    elsif params[:commit] == "Remove items"
       @stock_disposal.remove_item(params[:item])
       flash[:notice] = "Stock Disposal Item was successfully removed"
    end
    redirect_to edit_stock_disposal_path(@stock_disposal)
  end

  def preview
    @stock_disposal = StockDisposal.find(params[:id])
    @settings = Setting.all
    render :layout => false
  end

    def settle
    @stock_disposal = StockDisposal.find(params[:id])
    if params[:status_id].to_i == 1
       pass = @stock_disposal.check_settle
       if pass
         flash[:notice] = "Stock Disposal was successfully settled"
       else
         flash[:error] = "Stock disposal unsucessfully settled. Please fill the stock disposal item"
       end
    elsif params[:status_id].to_i == 2
       @stock_disposal.settled = false
       @stock_disposal.save!
    end
    redirect_to edit_stock_disposal_path(@stock_disposal)
  end

   def unsettled
    @stock_disposals = StockDisposal.unsettled.paginate(:page => params[:page], :per_page => 50)
  end

   def post_quantity
    @stock_disposal = StockDisposal.find(params[:id])
    if @stock_disposal.post_quantity
      flash[:notice] = "Stock Disposal was successfully post quantity"
    else
      flash[:error] = "Stock Disposal is already posted"
    end
    redirect_to edit_stock_disposal_path(@stock_disposal)
  end

  def show_popup
     @product = Product.find(params[:id])
     @result = @product.collect_virtual_quantity
    render :layout => false

 end
 def item_new_page
   @search = Product.search(params[:search])
   @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 20)
   @stock_disposal = StockDisposal.find(params[:id])
   @stock_disposal_item = @stock_disposal.stock_disposal_items.new
  end

  def removed_item
    @stock_disposal = StockDisposal.find(params[:id])
     params[:item] ||= []
    if params[:item].any?
     @stock_disposal.remove_item(params[:item])
      flash[:notice] = "Stock Disposal was successfully removed"
    else
      flash[:error] = "must choose at least one item"
    end
   redirect_to item_new_page_stock_disposal_path(@stock_disposal)
 end

end
