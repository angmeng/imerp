class PurchaseRequisitionsController < ApplicationController
  before_filter :require_user
 
  
  # GET /purchase_requisitions
  # GET /purchase_requisitions.xml
  

  def index
    @search = PurchaseRequisition.search(params[:search])
    @purchase_requisitions = @search.order('pr_date DESC , created_at DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)
    
  end

  # GET /purchase_requisitions/1
  # GET /purchase_requisitions/1.xml
  def show
    @purchase_requisition = PurchaseRequisition.find(params[:id])
  end

  # GET /purchase_requisitions/new
  # GET /purchase_requisitions/new.xml
  def new
    @purchase_requisition = PurchaseRequisition.new
    @purchase_requisition.pr_date = Date.today
    @purchase_requisition.issued_user_id = current_user.id
    @purchase_requisition.save!
    session[:supplier] = 0
    redirect_to edit_purchase_requisition_path(@purchase_requisition)

  end
 
  # GET /purchase_requisitions/1/edit
  def edit
    initial_data
    @search = Product.search(params[:search])
    @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 20)
    @purchase_requisition = PurchaseRequisition.find(params[:id])
    @purchase_requisition_item = @purchase_requisition.purchase_requisition_items.new
    session[:supplier] = 0
  end
  def update_info
    @purchase_requisition = PurchaseRequisition.find(params[:id])
    input = Date.parse(params[:purchase_requisition][:pr_date])
    if input > Date.today
        flash[:error] = "Please select valid date "
    else
    @purchase_requisition.update_attributes(params[:purchase_requisition])
    flash[:notice] = "Purchase Requisition was successfully updated"
    
  end
  redirect_to edit_purchase_requisition_path(@purchase_requisition)
  end
  

  # POST /purchase_requisitions
  # POST /purchase_requisitions.xml
  def create
    @purchase_requisition = PurchaseRequisition.new(params[:purchase_requisition])
    #if check_validation
      if @purchase_requisition.save
        #@purchase_requisition.add_item(params[:item])
        redirect_to(edit_purchase_requisition_path(@purchase_requisition), :notice => 'Purchase Requisition was successfully created.')
      else
        render :action => "new" 
      end
    #else
    #  initial_data
    #  flash[:error] = "Please fill in the item information"
    #  render :action => "new"
    #end
 
  end

  # PUT /purchase_requisitions/1
  # PUT /purchase_requisitions/1.xml
  def update
    @purchase_requisition = PurchaseRequisition.find(params[:id])

    respond_to do |format|
      if @purchase_requisition.update_attributes(params[:purchase_requisition])
        format.html { redirect_to(@purchase_requisition, :notice => 'Purchase Requisition was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @purchase_requisition.errors, :status => :unprocessable_entity }
      end
    end
  end

   def show_code
    @product = Product.all(:conditions => ['code LIKE ?', "#{params[:search]}%"])
#    @product.each {|c|  c.code = c.screen_name   }
   end

  def remove_item
    item = PurchaseRequisitionItem.find(params[:id])
    item.destroy
    flash[:notice] = "Purchase Requisition Item was successfully removed"
    redirect_to edit_purchase_requisition_path(item.purchase_requisition)
  end

  def update_item
    @purchase_requisition = PurchaseRequisition.find(params[:id])
    if params[:commit] == "Update items"
      errors = @purchase_requisition.update_item(params[:item])
       if errors.empty?
          flash[:notice] = "Purchase Requisition Item was successfully updated"
       else
          flash[:error] = errors
       end
     
    elsif params[:commit] == "Confirm items"
      check = @purchase_requisition.check_settle
      if check
        @purchase_requisition.confirm_item(params[:item])
        flash[:notice] = "Purchase Requisition Item was successfully confirmed"
      else
        flash[:error] = "PR unsucessfully confirm. Please fill the PR item in valid value"
      end
      elsif params[:commit] == "Remove items"
      @purchase_requisition.remove_item(params[:item])
      flash[:notice] = "Purchase Requisition Item was successfully removed"
    end
    redirect_to edit_purchase_requisition_path(@purchase_requisition)
  end

  def add_item
  @purchase_requisition = PurchaseRequisition.find(params[:id])
    if params[:supplier_id].to_i > 0
      supplier = Supplier.find(params[:supplier_id].to_i)
      errors = @purchase_requisition.add_item(params[:item],supplier)
      if errors.empty?
        flash[:notice] = "Purchase Requisition Item was successfully added"
       else
         flash[:error] = errors
       end
       if params[:commit] == "Add and Return"
           redirect_to edit_purchase_requisition_path(@purchase_requisition)
        elsif params[:commit] == "Add and Continue"
          redirect_to item_new_page_purchase_requisition_path(@purchase_requisition)
        end
    else
        flash[:error] = "Purchase Requisition item uncessfully added. Please add supplier first "
        redirect_to item_new_page_purchase_requisition_path(@purchase_requisition)
    end
    

  end
#    @purchase_requisition = PurchaseRequisition.find(params[:id])
#    supplier = Supplier.find(params[:supplier][:supplier_id])
#    if supplier
#      @purchase_requisition.add_item(params[:item],supplier)
#      flash[:notice] = "Purchase Requisition Item was successfully added"
#    else
#      flash[:error] = "Select Supplier of PR to add item"
#    end
#     if params[:commit] == "Add Item"
#       redirect_to edit_purchase_requisition_path(@purchase_requisition)
#     elsif params[:commit] == "Add Item and continue add"
#         redirect_to item_new_page_purchase_requisition_path(@purchase_requisition)
#     end
 

  def add_auto_complete_item
    @purchase_requisition = PurchaseRequisition.find(params[:id])
     if params[:supplier_id].to_i > 0
       supplier = Supplier.find(params[:supplier_id].to_i)
         @purchase_requisition.add_autocomplete_item(params[:purchase_requisition],supplier)
           flash[:notice] = "Purchase Requisition Item was successfully added"
     else
      flash[:error] = "Select Supplier of PR to add item"
    end
    redirect_to item_new_page_purchase_requisition_path(@purchase_requisition)
  end

  def send_for_approval
    @purchase_requisition = PurchaseRequisition.find(params[:id])
      pass = @purchase_requisition.check_settle
       if pass
         if @purchase_requisition.send_for_approval
          flash[:notice] = "Purchase Requisition was successfully sent for approval"
         else
          flash[:error] = "The PR does not have any confirmed item"
         end
       else
         flash[:error] = "PR unsucessfully send for approval. Please fill the PR item"
       end    
  
    redirect_to edit_purchase_requisition_path(@purchase_requisition)
  end

  def approve
    @purchase_requisition = PurchaseRequisition.find(params[:id])
     pass = @purchase_requisition.check_settle
       if pass
          if @purchase_requisition.approve(current_user.id)
            @purchase_requisition.generate_po
            flash[:notice] = "Purchase Requisition was successfully approved"
          else
            flash[:error] = "Purchase Requisition cannot be approved. You might not have any confirmed item or invalid PR information."
          end
       else
         flash[:error] = "PR unsucessfully approved. Please fill the PR item"
       end
    redirect_to edit_purchase_requisition_path(@purchase_requisition)
  end

  def regenerate_po
    @purchase_requisition = PurchaseRequisition.find(params[:id])
    @purchase_requisition.regenerate_po
    flash[:notice] = "PO regenerated"
    redirect_to edit_purchase_requisition_path(@purchase_requisition)
  end

  def void
    @purchase_requisition = PurchaseRequisition.find(params[:id])
    @purchase_requisition.void = true
    @purchase_requisition.save!
    flash[:notice] = "Successfully voided"
    redirect_back_or_default purchase_requisitions_url
  end

  def destroy
    @purchase_requisition = PurchaseRequisition.find(params[:id])
    if @purchase_requisition.verify_for_destroy
      flash[:notice] = "Purchase Requisition was successfully Destroyed"
    else
      flash[:error] = "Error!!"
    end
    redirect_back_or_default(purchase_requisitions_url)
  end

  def preview
    @purchase_requisition = PurchaseRequisition.find(params[:id])
    @settings = Setting.all
    render :layout => false
  end

  

  def show_popup
    @product = Product.find(params[:id])
    @result = @product.collect_virtual_quantity
    render :layout => false
  end


   def item_new_page
    initial_data
    @search = Product.search(params[:search])
    @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 20)
    @purchase_requisition = PurchaseRequisition.find(params[:id])
    @purchase_requisition_item = @purchase_requisition.purchase_requisition_items.new
    if session[:supplier].to_i > 0
     @supplier = Supplier.find(session[:supplier])
  end
  end

  def removed_item
     @purchase_requisition = PurchaseRequisition.find(params[:id])
      params[:item] ||= []
    if params[:item].any?
      @purchase_requisition.remove_pr_item(params[:item])
      flash[:notice] = "Purchase Requisition Item was successfully removed"
    else
      flash[:error] = "must choose at least one item"
    end
   redirect_to item_new_page_purchase_requisition_path(@purchase_requisition)
 end
 
 def add_supplier
    @search = Supplier.search(params[:search])
    @suppliers = @search.order('code ASC').all.uniq.paginate(:page => params[:page], :per_page => 20)
  end

  def session_supplier
      @purchase_requisition = PurchaseRequisition.find(params[:id])
     if params[:supplier]
        supplier = Supplier.find(params[:supplier])
        session[:supplier] = supplier.id
        redirect_to item_new_page_purchase_requisition_path(@sales_order)
     else
       session[:supplier] = 0
       flash[:error] = "Supplier uncessfully added. Please check Supplier "
       redirect_to add_supplier_purchase_requisition_path(@sales_order)
    end

  end

  private

  def initial_data
    @suppliers = Supplier.order("code").map {|c| [c.code_name, c.id]}
    @products = Product.order("code").map {|c| [c.code_name, c.id]}
  end

  def check_validation
    checked = true
    if params[:item][:product_id] and params[:item][:supplier_id]
      unless params[:item][:quantity].blank? or params[:item][:unit_price].blank?
        checked = false unless valid_numericality(params[:item])
      else
        checked = false
      end 
    else
      checked = false
    end
    checked
  end

  def valid_numericality(item)
    if item[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or item[:unit_price].index(/[abcdefghijklmnopqrstuvwxyz]/)
      return false
    else
      return true
    end
  end

  



  
end
