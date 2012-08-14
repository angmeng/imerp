class InvoicesController < ApplicationController
  before_filter :require_user
  # GET /invoices
  # GET /invoices.xml


  def index
    @search = Invoice.search(params[:search])
    @invoices = @search.order('invoice_date DESC, created_at DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
      format.json { render :json => @invoices.map(&:attributes)}
    end
  end

  def query
    @invoices = Invoice.unpaid.where("name LIKE ?", "%#{params[:q]}%")

      respond_to do |format|
      format.html
      format.xml  { render :xml => @invoices }
      format.json { render :json => @invoices.map(&:attributes)}
    end
  end

  # GET /invoices/1
  # GET /invoices/1.xml
  def show
    @invoice = Invoice.find(params[:id])
    @current_items = @invoice.invoice_items

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invoice }
    end
  end

#  def update_info
#    @invoice = Invoice.find(params[:id])
#    @invoice.update_attributes(params[:invoice])
#    flash[:notice] = "Invoice was successfully updated"
#    redirect_to edit_invoice_path(@invoice)
#  end

  # GET /invoices/new
  # GET /invoices/new.xml
  def new
    @invoice = Invoice.new
    @invoice.invoice_date = Date.today
    @invoice.end_invoice_date = Date.today
    @invoice.save!
    @do = DeliveryOrder.unimported.order('delivery_order_date DESC').order('created_at DESC')
    redirect_to edit_invoice_path(@invoice)

  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
    @search = DeliveryOrder.settled.search(params[:search])
    @search.customer_id_equals = @invoice.customer_id
    @delivery_orders = @search.order('delivery_order_date DESC, created_at DESC').all.uniq.paginate(:page => params[:page], :per_page => 50)
    @items = @invoice.invoice_items
     
  end
 
  
  # POST /invoices
  # POST /invoices.xml
  def create
   @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to(edit_invoice_path( @invoice), :notice => 'Invoice was successfully created.') }
        format.xml  { render :xml =>  @invoice, :status => :created, :location =>  @invoice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml =>  @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_do
    @invoice = Invoice.find(params[:id])
    @items = @invoice.invoice_items
    if params[:commit] == "Update Items"
       @invoice.update_item(params[:item])
       flash[:notice] = "Invoice Item was successfully updated"
    elsif params[:commit] == "Remove Items"
       @invoice.remove_item(params[:item])
       flash[:notice] = "Invoice Item was successfully removed"
    end
    redirect_to edit_invoice_path(@invoice)
  end

  def unsettled
    @invoices = Invoice.unsettled.paginate(:page => params[:page], :per_page => 50)
  end

  def add_auto_complete_delivery_order
    @invoice = Invoice.find(params[:id])
        errors = @invoice.add_autocomplete_delivery_order(params[:invoice])
         if errors.empty?
          flash[:notice] = "Invoice Item was successfully added"
        else
           flash[:error] = errors
        end
     redirect_to item_new_page_invoice_path(@invoice)
  end
  
  def add_delivery_order
    @invoice = Invoice.find(params[:id])
    params[:item] ||= []
    if params[:item].any?
      errors = @invoice.add_do(params[:item])
      if errors.empty?
        flash[:notice] = "Invoice Item was successfully added"
      else
        flash[:error] = errors
      end
    else
     flash[:error] = "Must choose at least one item"
    end
      if params[:commit] == "Add and Return"
        redirect_to edit_invoice_path(@invoice)
      elsif params[:commit] == "Add and Continue"
          redirect_to item_new_page_invoice_path(@invoice)
     end
end


  # PUT /invoices/1
  # PUT /invoices/1.xml
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

 def update_info
   @invoice = Invoice.find(params[:id])
    if params[:commit] == "Add customer"
      if params[:invoices]
         found = @invoice.check_customer(params[:invoices])
         if found
          flash[:notice] = "Invoice was successfully update"
          else
             flash[:error] = "Invoice was unsuccessfully updated. Delete all the DO before change the customer"
          end
           redirect_to edit_invoice_path(@invoice)
       else
       flash[:error] = "Customer uncessfully added. Please check Customer "
       redirect_to add_customer_invoice_path(@invoice)
       end
    elsif params[:commit] == "Update info"
       input = Date.parse(params[:invoice][:invoice_date])
       input2 = Date.parse(params[:invoice][:end_invoice_date])
        if input > Date.today or input2 > Date.today or input > input2
           flash[:error] = "Please select valid date "
        else
          found = @invoice.update_info(params[:invoice])
         if found
            flash[:notice] = "Invoice was successfully update"
          else
             flash[:error] = "Invoice was unsuccessfully updated. Delete all the DO before change the customer"
          end
        end
       redirect_to edit_invoice_path(@invoice)
     end
 end

  # DELETE /invoices/1
  # DELETE /invoices/1.xml

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.verify_for_destroy
    flash[:notice] = "Invoice was successfully voided"

    respond_to do |format|
      format.html { redirect_to(invoices_url) }
      format.xml  { head :ok }
    end
  end

  
  def preview
    @invoice = Invoice.find(params[:id])
    @invoice_item = @invoice.invoice_items
    
    @settings = Setting.all
    render :layout => false
  end
  def item_new_page
    @invoice = Invoice.find(params[:id])
    @search = DeliveryOrder.settled.search(params[:search])
    @search.customer_id_equals = @invoice.customer_id
   @delivery_orders = @search.order('delivery_order_date DESC, created_at DESC').all.uniq.paginate(:page => params[:page], :per_page => 10)
    @items = @invoice.invoice_items
  end

  def removed_do
     @invoice = Invoice.find(params[:id])
     params[:item] ||= []
    if params[:item].any?
       @invoice.remove_do(params[:item])
     flash[:notice] = "Invoice Item was successfully removed"
    else
      flash[:error] = "must choose at least one item"
    end
  redirect_to item_new_page_invoice_path(@invoice)

  end
  
   def add_customer
    @search = Customer.search(params[:search])
    @customers = @search.order('code ASC').all.uniq.paginate(:page => params[:page], :per_page => 20)
  end

   def settle
    @invoice = Invoice.find(params[:id])
    @invoice.imported = true
    @invoice.save!
     redirect_to edit_invoice_path(@invoice)
   end

  end

   
  

