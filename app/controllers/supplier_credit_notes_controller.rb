class SupplierCreditNotesController < ApplicationController
  before_filter :require_user
  # GET /supplier_credit_notes
  # GET /supplier_credit_notes.xml
 
  def index
  @search = SupplierCreditNote.search(params[:search])
  @supplier_credit_notes = @search.order('supplier_credit_note_date DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @supplier_credit_notes }
    end
  end

  # GET /supplier_credit_notes/1
  # GET /supplier_credit_notes/1.xml
  def show
    @supplier_credit_note = SupplierCreditNote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @supplier_credit_note }
    end
  end

  # GET /supplier_credit_notes/new
  # GET /supplier_credit_notes/new.xml
  def new
    @supplier_credit_note = SupplierCreditNote.new
    @supplier_credit_note.supplier_credit_note_date = Date.today
    @supplier_credit_note.supplier_id = 0
    @supplier_credit_note.save!
    session[:supplier] = 0
    redirect_to edit_supplier_credit_note_path(@supplier_credit_note)
    
  end

  # GET /supplier_credit_notes/1/edit
  def edit
    @supplier_credit_note = SupplierCreditNote.find(params[:id])
    @search = Product.search(params[:search])
    @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 10)
    session[:supplier] = 0
  end

  # POST /supplier_credit_notes
  # POST /supplier_credit_notes.xml
  def create
    @supplier_credit_note = SupplierCreditNote.new(params[:supplier_credit_note])
    #if check_validation
      if @supplier_credit_note.save
    redirect_to(edit_supplier_credit_note_path(@supplier_credit_note), :notice => 'Return To Supplier was successfully created.')
      else
        render :action => "new"
      end

  end
  # PUT /supplier_credit_notes/1
  # PUT /supplier_credit_notes/1.xml
  def update
    @supplier_credit_note = SupplierCreditNote.find(params[:id])

    respond_to do |format|
      if @supplier_credit_note.update_attributes(params[:supplier_credit_note])
        format.html { redirect_to(@supplier_credit_note, :notice => 'Return To Supplier was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @supplier_credit_note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /supplier_credit_notes/1
  # DELETE /supplier_credit_notes/1.xml
  def destroy
    @supplier_credit_note = SupplierCreditNote.find(params[:id])
    @supplier_credit_note.voided = true
    @supplier_credit_note.save!
    flash[:notice] = "Voided Successfully"


    respond_to do |format|
      format.html { redirect_to(supplier_credit_notes_url) }
      format.xml  { head :ok }
    end
  end
   def remove_item
    item = SupplierCreditNoteItem.find(params[:id])
    item.destroy
    flash[:notice] = "Return To Supplier Item was successfully removed"
    redirect_to edit_supplier_credit_note_path(item.supplier_credit_note)
  end

#   def update_info
#    @supplier_credit_note = SupplierCreditNote.find(params[:id])
#    @supplier_credit_note.update_attributes(params[:supplier_credit_note])
#    flash[:notice] = "Return To Supplier was successfully updated"
#    redirect_to edit_supplier_credit_note_path(@supplier_credit_note)
#  end
def update_info
   @supplier_credit_note = SupplierCreditNote.find(params[:id])
    if params[:commit] == "Add supplier"
      if params[:supplier_credit_note]
       @supplier_credit_note.update_attributes(params[:supplier_credit_note])
       flash[:notice] = "Return To Supplier was successfully updated"
         redirect_to edit_supplier_credit_note_path(@supplier_credit_note)
     else
       flash[:error] = "Supplier uncessfully added. Please check supplier "
       redirect_to add_supplier_supplier_credit_note_path(@supplier_credit_note)
     end
    elsif params[:commit] == "Update info"
       input = Date.parse(params[:supplier_credit_note][:supplier_credit_note_date])
         if input > Date.today
           flash[:error] = "Please select valid date "
        else
          @supplier_credit_note.update_attributes(params[:supplier_credit_note])
           flash[:notice] = "Return To Supplier was successfully updated"
        end
        redirect_to edit_supplier_credit_note_path(@supplier_credit_note)
     end
 end

 def update_item
   @supplier_credit_note = SupplierCreditNote.find(params[:id])
   @items = @supplier_credit_note.supplier_credit_note_items
    if params[:commit] == "Update items"
     errors = @supplier_credit_note.update_item(params[:item])
      if errors.empty?
           flash[:notice] = "Return To Supplier Item was successfully updated"
      else
          flash[:error] = errors
      end
    elsif params[:commit] == "Remove items"
      @supplier_credit_note.remove_item(params[:item])
      flash[:notice] = "Return To Supplier Item was successfully removed"
    end
      redirect_to edit_supplier_credit_note_path(@supplier_credit_note)
 end

  def add_item
    @supplier_credit_note = SupplierCreditNote.find(params[:id])
    errors = @supplier_credit_note.add_item(params[:item])
    if errors.empty?
         flash[:notice] = "Return To Supplier Item was successfully added"
    else
         flash[:error] = errors
    end
    
    if params[:commit] == "Add and Return"
     redirect_to edit_supplier_credit_note_path(@supplier_credit_note)
    elsif params[:commit] == "Add and Continue"
    redirect_to item_new_page_supplier_credit_note_path(@supplier_credit_note)
  end
  end

  def add_auto_complete_item
    @supplier_credit_note = SupplierCreditNote.find(params[:id])
     @supplier_credit_note.add_autocomplete_item(params[:supplier_credit_note])
    flash[:notice] = "Return To Supplier Item was successfully added"
   redirect_to item_new_page_supplier_credit_note_path(@supplier_credit_note)
  end

  def settle
    @supplier_credit_note = SupplierCreditNote.find(params[:id])
    if params[:status_id].to_i == 1
       result = @supplier_credit_note.check_supplier
        if result
            pass = @supplier_credit_note.check_settle
              if pass
                  flash[:notice] = " Return To Supplier was successfully settled"
              else
                  flash[:error] = "Return To Supplier unsucessfully to settle. Please fill all the RTS item info"
              end
        else
           flash[:error] = "Return To Supplier unsucessfully to settle. Please select the supplier of RTS"
        end
     elsif params[:status_id].to_i == 2
       @supplier_credit_note.settled = false
       @supplier_credit_note.save!
    end
    redirect_to edit_supplier_credit_note_path(@supplier_credit_note)
  end

   def unsettled
    @supplier_credit_notes = SupplierCreditNote.unsettled.paginate(:page => params[:page], :per_page => 50)
  end

   def post_quantity
    @supplier_credit_note = SupplierCreditNote.find(params[:id])
    if @supplier_credit_note.post_quantity
      flash[:notice] = "Return To Supplier was successfully post quantity "
    else
      flash[:error] = "Return To Supplier is already posted"
    end
    redirect_to edit_supplier_credit_note_path(@supplier_credit_note)
  end

  def preview
    @supplier_credit_note = SupplierCreditNote.find(params[:id])
     @items = @supplier_credit_note.supplier_credit_note_items
     @settings = Setting.all
    render :layout => false
  end
  def show_popup
     @product = Product.find(params[:id])
     @result = @product.collect_virtual_quantity
    render :layout => false
  end

  def item_new_page
    @supplier_credit_note = SupplierCreditNote.find(params[:id])
    @search = Product.search(params[:search])
    @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 10)
  end

  def removed_item
      @supplier_credit_note = SupplierCreditNote.find(params[:id])
       params[:item] ||= []
      if params[:item].any?
        @supplier_credit_note.removed_scn_item(params[:item])
        flash[:notice] = "Return To Supplier was successfully removed"
      else
        flash[:error] = "must choose at least one item"
      end
  
   redirect_to item_new_page_supplier_credit_note_path(@supplier_credit_note)
 end
def add_supplier
    @search = Supplier.search(params[:search])
    @suppliers = @search.order('code ASC').all.uniq.paginate(:page => params[:page], :per_page => 20)
  end
end
