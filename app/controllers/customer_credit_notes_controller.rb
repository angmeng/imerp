class CustomerCreditNotesController < ApplicationController
  before_filter :require_user
  # GET /customer_credit_notes
  # GET /customer_credit_notes.xml

  def index
    @search = CustomerCreditNote.search(params[:search])
    @customer_credit_notes = @search.order('cust_credit_note_date DESC, created_at DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customer_credit_notes }
    end
  end

  # GET /customer_credit_notes/1
  # GET /customer_credit_notes/1.xml
  def show
    @customer_credit_note = CustomerCreditNote.find(params[:id])
    @search = Product.search(params[:search])
    @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 10)
  end

  # GET /customer_credit_notes/new
  # GET /customer_credit_notes/new.xml
  def new
    @customer_credit_note = CustomerCreditNote.new
    @customer_credit_note.customer_id = 0
    @customer_credit_note.cust_credit_note_date = Date.today
    @customer_credit_note.save!
    session[:customer] = 0
    redirect_to edit_customer_credit_note_path(@customer_credit_note)

  end

  # GET /customer_credit_notes/1/edit
  def edit
    @customer_credit_note = CustomerCreditNote.find(params[:id])
    @search = Product.search(params[:search])
    @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 10)
    session[:customer] = 0
  end

#  def update_info
#    @customer_credit_note = CustomerCreditNote.find(params[:id])
#    @customer_credit_note.update_attributes(params[:customer_credit_note])
#    flash[:notice] = "Receive From Customer was successfully updated"
#   redirect_to edit_customer_credit_note_path(@customer_credit_note)
#  end

 def update_info
   @customer_credit_note = CustomerCreditNote.find(params[:id])
    if params[:commit] == "Add customer"
      if params[:customer_credit_note]
       @customer_credit_note.update_attributes(params[:customer_credit_note])
       flash[:notice] = "Receive From Customer was successfully updated"
         redirect_to edit_customer_credit_note_path(@customer_credit_note)
     else
       flash[:error] = "Customer uncessfully added. Please check customer "
       redirect_to add_customer_customer_credit_note_path(@customer_credit_note)
     end
    elsif params[:commit] == "Update info"
       input = Date.parse(params[:customer_credit_note][:cust_credit_note_date])
         if input > Date.today
           flash[:error] = "Please select valid date "
        else
          @customer_credit_note.update_attributes(params[:customer_credit_note])
           flash[:notice] = "Receive From Customer was successfully updated"
        end
        redirect_to edit_customer_credit_note_path(@customer_credit_note)
     end
 end

  # POST /customer_credit_notes
  # POST /customer_credit_notes.xml
  def create
     @customer_credit_note = CustomerCreditNote.new(params[:customer_credit_note])
    #if check_validation
      if @customer_credit_note.save
    redirect_to(edit_customer_credit_note_path(@customer_credit_note), :notice => 'Receive From Customer was successfully created.')
      else
        render :action => "new"
      end
  end

  # PUT /customer_credit_notes/1
  # PUT /customer_credit_notes/1.xml
  def update
    @customer_credit_note = CustomerCreditNote.find(params[:id])
    respond_to do |format|
      if @customer_credit_note.update_attributes(params[:customer_credit_note])
        format.html { redirect_to(@customer_credit_note, :notice => 'Receive From Customer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer_credit_note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_credit_notes/1
  # DELETE /customer_credit_notes/1.xml
  def destroy
    @customer_credit_note = CustomerCreditNote.find(params[:id])
    @customer_credit_note.voided = true
    @customer_credit_note.save!
    flash[:notice] = "Voided Successfully"

    respond_to do |format|
      format.html { redirect_to(customer_credit_notes_url) }
      format.xml  { head :ok }
    end
  end

  def remove_item
    item = CustomerCreditNoteItem.find(params[:id])
    item.destroy
    flash[:notice] = "Receive From Customer Item was successfully removed"
    redirect_to edit_customer_credit_note_path(item.customer_credit_note)
  end

  def update_item
   @customer_credit_note = CustomerCreditNote.find(params[:id])
    if params[:commit] == "Update items"
      errors = @customer_credit_note.update_item(params[:item])
      if errors.empty?
           flash[:notice] = "Receive From Customer Item was successfully updated"
      else
          flash[:error] = errors
      end
   elsif params[:commit] == "Remove items"
        @customer_credit_note.remove_item(params[:item])
        flash[:notice] = "Receive From Customer Item was successfully removed"
     end
        redirect_to edit_customer_credit_note_path(@customer_credit_note)
  end

  def add_item
    @customer_credit_note = CustomerCreditNote.find(params[:id])
    errors = @customer_credit_note.add_item(params[:item])
    if errors.empty?
         flash[:notice] = "Receive From Customer Item was successfully added"
    else
         flash[:error] = errors
    end
    if params[:commit] == "Add and Return"
      redirect_to edit_customer_credit_note_path(@customer_credit_note)
    elsif params[:commit] == "Add and Continue"
       redirect_to item_new_page_customer_credit_note_path(@customer_credit_note)
    end

  end

  
   def add_auto_complete_item
    @customer_credit_note = CustomerCreditNote.find(params[:id])
    @customer_credit_note.add_autocomplete_item(params[:customer_credit_note])
    flash[:notice] = "Receive From Customer Item was successfully added"

    redirect_to item_new_page_customer_credit_note_path(@customer_credit_note)
  end

  def settle
    @customer_credit_note = CustomerCreditNote.find(params[:id])
    if params[:status_id].to_i == 1
       result = @customer_credit_note.check_cust
        if result
            pass = @customer_credit_note.check_settle
              if pass
                  flash[:notice] = " Receive From Customer was successfully settled"
              else
                  flash[:error] = "Receive From Customer unsucessfully to settle. Please fill all the RFC item info"
              end
        else
           flash[:error] = "Receive From Customer unsucessfully to settle. Please select the customer of CCN"
        end
    elsif params[:status_id].to_i == 2
       @customer_credit_note.settled = false
       @customer_credit_note.save!
    end
    redirect_to edit_customer_credit_note_path(@customer_credit_note)
  end

   def unsettled
    @customer_credit_notes = CustomerCreditNote.unsettled.paginate(:page => params[:page], :per_page => 50)
  end

   def post_quantity
    @customer_credit_note = CustomerCreditNote.find(params[:id])
    if @customer_credit_note.post_quantity
      flash[:notice] = "Receive From Customer was successfully post quantity"
    else
      flash[:error] = "Receive From Customer is already posted"
    end
    redirect_to edit_customer_credit_note_path(@customer_credit_note)
  end

  def show_popup
     @product = Product.find(params[:id])
     @result = @product.collect_virtual_quantity
    render :layout => false
 end

 def preview
    @customer_credit_note = CustomerCreditNote.find(params[:id])
     @items = @customer_credit_note.customer_credit_note_items
     @settings = Setting.all
    render :layout => false
#    respond_to do |wants|
#        wants.html {
#          @customer_credit_notes = CustomerCreditNote.all(:order => "name")
#          }
#        wants.pdf {
#          output = Report.new.customer_credit_note
#           send_data output, :filename => "contact.pdf",
#                             :type => "application/pdf",
#                             :disposition  => "inline"
#          }
#      end
  end

 def item_new_page
    @customer_credit_note = CustomerCreditNote.find(params[:id])
    @search = Product.search(params[:search])
    @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 10)
  end
  
  def removed_item
    @customer_credit_note = CustomerCreditNote.find(params[:id])
    params[:item] ||= []
    if params[:item].any?
      @customer_credit_note.removed_ccn_item(params[:item])
      flash[:notice] = "Receive From Customer Item was successfully removed"
    else
      flash[:error] = "must choose at least one item"
    end
  redirect_to item_new_page_customer_credit_note_path(@customer_credit_note)
 end
 
def add_customer
    @search = Customer.search(params[:search])
    @customers = @search.order('code ASC').all.uniq.paginate(:page => params[:page], :per_page => 20)
  end

end
