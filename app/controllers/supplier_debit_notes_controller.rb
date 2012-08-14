class SupplierDebitNotesController < ApplicationController
  before_filter :require_user
  # GET /supplier_debit_notes
  # GET /supplier_debit_notes.xml

  def index
   @search = SupplierDebitNote.search(params[:search])
   @supplier_debit_notes = @search.order('supplier_debit_note_date DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @supplier_debit_notes }
    end
  end

  # GET /supplier_debit_notes/1
  # GET /supplier_debit_notes/1.xml
  def show
    @supplier_debit_note = SupplierDebitNote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @supplier_debit_note }
    end
  end

  # GET /supplier_debit_notes/new
  # GET /supplier_debit_notes/new.xml
  def new
    @supplier_debit_note = SupplierDebitNote.new
    @supplier_debit_note.supplier_debit_note_date = Date.today
    @supplier_debit_note.supplier_id = 0
    @supplier_debit_note.save!
    redirect_to edit_supplier_debit_note_path(@supplier_debit_note)
    
  end

  # GET /supplier_debit_notes/1/edit
  def edit
    @supplier_debit_note = SupplierDebitNote.find(params[:id])
    @search = Product.search(params[:search])
    @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 10)
  end

  # POST /supplier_debit_notes
  # POST /supplier_debit_notes.xml
  def create
  @supplier_debit_note = SupplierDebitNote.new(params[:supplier_debit_note])
    #if check_validation
      if @supplier_debit_note.save
    redirect_to(edit_supplier_debit_note_path(@supplier_debit_note), :notice => 'Receive From Supplier was successfully created.')
      else
        render :action => "new"
      end
  end

  # PUT /supplier_debit_notes/1
  # PUT /supplier_debit_notes/1.xml
  def update
    @supplier_debit_note = SupplierDebitNote.find(params[:id])

    respond_to do |format|
      if @supplier_debit_note.update_attributes(params[:supplier_debit_note])
        format.html { redirect_to(@supplier_debit_note, :notice => 'Receive From Supplier note was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @supplier_debit_note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /supplier_debit_notes/1
  # DELETE /supplier_debit_notes/1.xml
  def destroy
    @supplier_debit_note = SupplierDebitNote.find(params[:id])
    @supplier_debit_note.voided = true
    @supplier_debit_note.save!
    flash[:notice] = "Voided Successfully"

    respond_to do |format|
      format.html { redirect_to(supplier_debit_notes_url) }
      format.xml  { head :ok }
    end
  end

#  def update_info
#    @supplier_debit_note = SupplierDebitNote.find(params[:id])
#    @supplier_debit_note.update_attributes(params[:supplier_debit_note])
#    flash[:notice] = "Receive From Supplier was successfully updated"
#    redirect_to edit_supplier_debit_note_path(@supplier_debit_note)
#  end
  def update_info
   @supplier_debit_note = SupplierDebitNote.find(params[:id])
    if params[:commit] == "Add supplier"
      if params[:supplier_debit_note]
       @supplier_debit_note.update_attributes(params[:supplier_debit_note])
       flash[:notice] = "Receive From Supplier was successfully updated"
         redirect_to edit_supplier_debit_note_path(@supplier_debit_note)
     else
       flash[:error] = "Supplier uncessfully added. Please check supplier "
       redirect_to add_supplier_supplier_debit_note_path(@supplier_debit_note)
     end
    elsif params[:commit] == "Update info"
       input = Date.parse(params[:supplier_debit_note][:supplier_debit_note_date])
         if input > Date.today
           flash[:error] = "Please select valid date "
        else
          @supplier_debit_note.update_attributes(params[:supplier_debit_note])
           flash[:notice] = "Receive From Supplierr was successfully updated"
        end
        redirect_to edit_supplier_debit_note_path(@supplier_debit_note)
     end
 end


 def update_item
   @supplier_debit_note = SupplierDebitNote.find(params[:id])
   @items = @supplier_debit_note.supplier_debit_note_items
     if params[:commit] == "Update items"
      errors = @supplier_debit_note.update_item(params[:item])
       if errors.empty?
           flash[:notice] = "Receive From Supplier was successfully updated"
      else
          flash[:error] = errors
      end
      
    elsif params[:commit] == "Remove items"
      @supplier_debit_note.remove_item(params[:item])
      flash[:notice] = "Receive From Supplier was successfully removed"
    end
      redirect_to edit_supplier_debit_note_path(@supplier_debit_note)
  end


  def add_item
    @supplier_debit_note = SupplierDebitNote.find(params[:id])
    errors = @supplier_debit_note.add_item(params[:item])
    if errors.empty?
         flash[:notice] = "Return To Supplier Item was successfully added"
    else
         flash[:error] = errors
    end
    flash[:notice] = "Receive From Supplier Item was successfully added"
      if params[:commit] == "Add and Return"
     redirect_to edit_supplier_debit_note_path(@supplier_debit_note)
    elsif params[:commit] == "Add and Continue"
    redirect_to item_new_page_supplier_debit_note_path(@supplier_debit_note)
  end
 end

  def add_auto_complete_item
   
    @supplier_debit_note = SupplierDebitNote.find(params[:id])
    @supplier_debit_note.add_autocomplete_item(params[:supplier_debit_note])
      flash[:notice] = "Receive From Supplier Item was successfully added"
 

    redirect_to item_new_page_supplier_debit_note_path(@supplier_debit_note)
  end
  
  def settle
    @supplier_debit_note = SupplierDebitNote.find(params[:id])
    if params[:status_id].to_i == 1
       result = @supplier_debit_note.check_supplier
        if result
          pass = @supplier_debit_note.check_settle
            if pass
                flash[:notice] = " Receive From Supplier was successfully settled"
            else
                flash[:error] = "Receive From Supplier unsucessfully to settle. Please fill all the RFS item info"
            end
        else
           flash[:error] = "Receive From Supplier unsucessfully to settle. Please select the supplier of RFS"
        end
    elsif params[:status_id].to_i == 2
       @supplier_debit_note.settled = false
       @supplier_debit_note.save!
    end
    redirect_to edit_supplier_debit_note_path(@supplier_debit_note)
  end

   def unsettled
    @supplier_debit_notes = SupplierDebitNote.unsettled.paginate(:page => params[:page], :per_page => 50)
  end

   def post_quantity
    @supplier_debit_note = SupplierDebitNote.find(params[:id])
    if @supplier_debit_note.post_quantity
      flash[:notice] = "Receive From Supplier was successfully post quantity"
    else
      flash[:error] = "Receive From Supplier has been posted"
    end
    redirect_to edit_supplier_debit_note_path(@supplier_debit_note)
  end


  def preview
    @supplier_debit_note = SupplierDebitNote.find(params[:id])
     @items = @supplier_debit_note.supplier_debit_note_items
     @settings = Setting.all
    render :layout => false
  end
  def show_popup
     @product = Product.find(params[:id])
     @result = @product.collect_virtual_quantity
    render :layout => false

 end

  def item_new_page
    @supplier_debit_note = SupplierDebitNote.find(params[:id])
    @search = Product.search(params[:search])
    @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 10)
  end

  def removed_item
      @supplier_debit_note = SupplierDebitNote.find(params[:id])
       params[:item] ||= []
      if params[:item].any?
       @supplier_debit_note.removed_sdn_item(params[:item])
        flash[:notice] = "Receive From Supplier Item was successfully removed"
      else
        flash[:error] = "must choose at least one item"
      end
   redirect_to item_new_page_supplier_debit_note_path(@supplier_debit_note)
 end
 
 def add_supplier
    @search = Supplier.search(params[:search])
    @suppliers = @search.order('code ASC').all.uniq.paginate(:page => params[:page], :per_page => 20)
  end

end

