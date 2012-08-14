class CustomerDebitNotesController < ApplicationController
  before_filter :require_user
  # GET /customer_debit_notes
  # GET /customer_debit_notes.xml

  def index
   @search = CustomerDebitNote.search(params[:search])
    @customer_debit_notes = @search.order('cust_debit_note_date DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customer_debit_notes }
    end
  end

  # GET /customer_debit_notes/1
  # GET /customer_debit_notes/1.xml
  def show
    @customer_debit_note = CustomerDebitNote.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customer_debit_note }
    end
  end

  # GET /customer_debit_notes/new
  # GET /customer_debit_notes/new.xml
  def new
    @customer_debit_note = CustomerDebitNote.new
    @customer_debit_note.cust_debit_note_date = Date.today
    @customer_debit_note.customer_id = 0
    @customer_debit_note.save!
    session[:customer] = 0
    redirect_to edit_customer_debit_note_path(@customer_debit_note)
   
  end

  # GET /customer_debit_notes/1/edit
  def edit
    @customer_debit_note = CustomerDebitNote.find(params[:id])
    @search = Product.search(params[:search])
    @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 10)
  end

  # POST /customer_debit_notes
  # POST /customer_debit_notes.xml
  def create
     @customer_debit_note = CustomerDebitNote.new(params[:customer_debit_note])
    #if check_validation
      if @customer_debit_note.save
    redirect_to(edit_customer_debit_note_path(@customer_debit_note), :notice => 'Return To Customer was successfully created.')
      else
        render :action => "new"
      end
  end

#  def update_info
#    @customer_debit_note = CustomerDebitNote.find(params[:id])
#    @customer_debit_note.update_attributes(params[:customer_debit_note])
#    flash[:notice] = "Return To Customer was successfully update"
#    redirect_to edit_customer_debit_note_path(@customer_debit_note)
#  end
def update_info
  @customer_debit_note = CustomerDebitNote.find(params[:id])
    if params[:commit] == "Add customer"
      if params[:customer_debit_note]
       @customer_debit_note.update_attributes(params[:customer_debit_note])
       flash[:notice] = "Return To Customer was successfully updated"
         redirect_to edit_customer_debit_note_path(@customer_debit_note)
     else
       flash[:error] = "Customer uncessfully added. Please check customer "
       redirect_to add_customer_customer_debit_note_path(@customer_debit_note)
     end
    elsif params[:commit] == "Update info"
       input = Date.parse(params[:customer_debit_note][:cust_debit_note_date])
         if input > Date.today
           flash[:error] = "Please select valid date "
        else
          @customer_debit_note.update_attributes(params[:customer_debit_note])
           flash[:notice] = "Return To Customer was successfully updated"
        end
        redirect_to edit_customer_debit_note_path(@customer_debit_note)
     end
 end

  # PUT /customer_debit_notes/1
  # PUT /customer_debit_notes/1.xml
  def update
    @customer_debit_note = CustomerDebitNote.find(params[:id])

    respond_to do |format|
      if @customer_debit_note.update_attributes(params[:customer_debit_note])
        format.html { redirect_to(@customer_debit_note, :notice => 'Return To Customer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer_debit_note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_debit_notes/1
  # DELETE /customer_debit_notes/1.xml
  def destroy
    @customer_debit_note = CustomerDebitNote.find(params[:id])
    @customer_debit_note.voided = true
    @customer_debit_note.save!
    flash[:notice] = "Voided Successfully"

    respond_to do |format|
      format.html { redirect_to(customer_debit_notes_url) }
      format.xml  { head :ok }
    end
  end

  def remove_item
    item = CustomerDebitNoteItem.find(params[:id])
    item.destroy
    flash[:notice] = "Return To Customer Item was successfully removed"
    redirect_to edit_customer_debit_note_path(item.customer_debit_note)
  end

 def update_item
   @customer_debit_note = CustomerDebitNote.find(params[:id])
   @items = @customer_debit_note.customer_debit_note_items
    if params[:commit] == "Update items"
      errors = @customer_debit_note.update_item(params[:item])
       if errors.empty?
           flash[:notice] = "Return To Customer Item was successfully updated"
      else
          flash[:error] = errors
      end
      
    elsif params[:commit] == "Remove items"
      @customer_debit_note.remove_item(params[:item])
      flash[:notice] = "Return To Customer Item was successfully removed"
    end
      redirect_to edit_customer_debit_note_path(@customer_debit_note)
  end

  def add_item
    @customer_debit_note = CustomerDebitNote.find(params[:id])
    errors = @customer_debit_note.add_item(params[:item])
    if errors.empty?
         flash[:notice] = "Return To Customer Item was successfully added"
    else
         flash[:error] = errors
    end
    
   if params[:commit] == "Add and Return"
     redirect_to edit_customer_debit_note_path(@customer_debit_note)
    elsif params[:commit] == "Add and Continue"
   redirect_to item_new_page_customer_debit_note_path(@customer_debit_note)
  end
  end

  def add_auto_complete_item
    @customer_debit_note = CustomerDebitNote.find(params[:id])
    @customer_debit_note.add_autocomplete_item(params[:customer_debit_note])
    flash[:notice] = "Return To Customer Item was successfully Added"

     redirect_to item_new_page_customer_debit_note_path(@customer_debit_note)
  end

  def settle
    @customer_debit_note = CustomerDebitNote.find(params[:id])
    if params[:status_id].to_i == 1
       result = @customer_debit_note.check_cust
       if result
          pass = @customer_debit_note.check_settle
            if pass
              flash[:notice] = " Return To Customer was successfully settled"
            else
              flash[:error] = "Return To Customer unsucessfully to settle. Please fill all the RTC item info"
            end
       else
       flash[:error] = "Return To Customer unsucessfully to settle. Please select the Customer of RTC"
       end

    elsif params[:status_id].to_i == 2
       @customer_debit_note.settled = false
       @customer_debit_note.save!
    end
    redirect_to edit_customer_debit_note_path(@customer_debit_note)
  end

   def unsettled
    @customer_debit_notes = CustomerDebitNote.unsettled.paginate(:page => params[:page], :per_page => 50)
  end

   def post_quantity
    @customer_debit_note = CustomerDebitNote.find(params[:id])
    if @customer_debit_note.post_quantity
      flash[:notice] = "Return To Customer was successfully post quantity"
    else
      flash[:error] = "Return To Customer is already posted"
    end
    redirect_to edit_customer_debit_note_path(@customer_debit_note)
  end
  
  def show_popup
     @product = Product.find(params[:id])
     @result = @product.collect_virtual_quantity
    render :layout => false
 end

 def preview
    @customer_debit_note = CustomerDebitNote.find(params[:id])
    @items = @customer_debit_note.customer_debit_note_items
    @settings = Setting.all
    render :layout => false
  end

 def item_new_page
    @customer_debit_note = CustomerDebitNote.find(params[:id])
    @search = Product.search(params[:search])
    @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 10)
  end

  def removed_item
    @customer_debit_note = CustomerDebitNote.find(params[:id])
    params[:item] ||= []
    if params[:item].any?
      @customer_debit_note.removed_cdn_item(params[:item])
      flash[:notice] = "Return To Customer Item was successfully removed"
       else
      flash[:error] = "must choose at least one item"
    end
   redirect_to item_new_page_customer_debit_note_path(@customer_debit_note)
 end

 def add_customer
    @search = Customer.search(params[:search])
    @customers = @search.order('code ASC').all.uniq.paginate(:page => params[:page], :per_page => 20)
  end

end
