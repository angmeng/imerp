class SupplierPaymentsController < ApplicationController
  before_filter :require_user
  # GET /supplier_payments
  # GET /supplier_payments.xml
 
  def index
    @search = SupplierPayment.search(params[:search])
    @supplier_payments = @search.order('supplier_payment_date DESC, created_at DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @supplier_payments }
    end
  end

  # GET /supplier_payments/1
  # GET /supplier_payments/1.xml
  def show
    @supplier_payment = SupplierPayment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @supplier_payment }
    end
  end

  # GET /supplier_payments/new
  # GET /supplier_payments/new.xml
  def new
    @supplier_payment = SupplierPayment.new
    @purchase_order=PurchaseOrder.unimported.order('Purchase_order_date DESC, created_at DESC')
    @supplier_payment.supplier_payment_date = Date.today
  
    @supplier_payment.save!
    redirect_to edit_supplier_payment_path(@supplier_payment)

   
  end

  # GET /supplier_payments/1/edit
  def edit
    @supplier_payment = SupplierPayment.find(params[:id])
    @search = PurchaseOrder.unpaid.search(params[:search])
    @search.supplier_id_equals = @supplier_payment.supplier_id
    @purchase_orders = @search.all.uniq.paginate(:page => params[:page], :per_page => 10)  
    @items = @supplier_payment.supplier_payment_items
    @payment = PaymentMethod.all
    
   
   
  end

  # POST /supplier_payments
  # POST /supplier_payments.xml
  def create
    @supplier_payment = SupplierPayment.new(params[:supplier_payment])
    #if check_validation
      if @supplier_payment.save
    redirect_to(edit_supplier_payment_path(@supplier_payment), :notice => 'Supplier Payment was successfully created.')
      else
        render :action => "new"
      end
  end
  # PUT /supplier_payments/1
  # PUT /supplier_payments/1.xml
  def update
    @supplier_payment = SupplierPayment.find(params[:id])

    respond_to do |format|
      if @supplier_payment.update_attributes(params[:supplier_payment])
        format.html { redirect_to(@supplier_payment, :notice => 'Supplier Payment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @supplier_payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /supplier_payments/1
  # DELETE /supplier_payments/1.xml
  def destroy
    @supplier_payment = SupplierPayment.find(params[:id])
    @supplier_payment.voided = true
    @supplier_payment.save!
    flash[:notice] = "Voided Successfully"

    respond_to do |format|
      format.html { redirect_to(supplier_payments_url) }
      format.xml  { head :ok }
    end
  end

  def update_info
  @supplier_payment = SupplierPayment.find(params[:id])
    if params[:commit] == "Add supplier"
      if params[:supplier_payment]
          found = @supplier_payment.check_supplier(params[:supplier_payment])
            if found
              flash[:notice] = "Supplier Payment was successfully updated"
            else
               flash[:error] = "Supplier Payment was unsuccessfully updated. Delete all the PO before change the supplier"
            end
          redirect_to edit_supplier_payment_path(@supplier_payment)
      else
         flash[:error] = "Supplier uncessfully added. Please check supplier "
         redirect_to add_supplier_supplier_payment_path(@supplier_payment)
      end
    elsif params[:commit] == "Update info"
       input = Date.parse(params[:supplier_payment][:supplier_payment_date])
          if input > Date.today
              flash[:error] = "Please select valid date "
          else
            if params[:supplier_payment][:payment_method_id]== ""
                 @supplier_payment.payment_method_id = nil
                 @supplier_payment.cheque_number = nil
                 @supplier_payment.bank = nil
                 @supplier_payment.cheque_date = nil
                 @supplier_payment.supplier_payment_date = params[:supplier_payment][:supplier_payment_date]
                 @supplier_payment.remark = params[:supplier_payment][:remark]
                 @supplier_payment.save!
           else
             @supplier_payment.supplier_payment(params[:supplier_payment])
             flash[:notice] = "Supplier Payment was successfully updated"
          end
         end
        redirect_to edit_supplier_payment_path(@supplier_payment)
   end
 end

def update_purchase_order
   @supplier_payment = SupplierPayment.find(params[:id])
    params[:item] ||= []
    if params[:commit] == "Update items"
      errors = @supplier_payment.update_items(params[:item])
        if errors.empty?
          flash[:notice] = "Supplier Payment Item was successfully updated"
        else
          flash[:error] = errors
        end
     elsif params[:commit] == "Remove items"
        errors = @supplier_payment.remove_item(params[:item])
       if errors.empty?
          flash[:notice] =  "Supplier Payment Item was successfully removed"
        else
          flash[:error] = errors
        end
    end
  redirect_to edit_supplier_payment_path(@supplier_payment)
  end

  def post_payment
    @supplier_payment = SupplierPayment.find(params[:id])
     result = @supplier_payment.check_settle
       if result
          if @supplier_payment.payment_paid
             @supplier_payment.settled = true
             @supplier_payment.save!
            flash[:notice] = "Supplier Payment was successfully posted"
          else
            @supplier_payment.settled = false
            @supplier_payment.save!
            flash[:error] = "Supplier Payment is already posted"
          end
       else
          flash[:error] = "Supplier Payment unsucessfully to settle. Please complete the supplier payment item "
      end
    redirect_to edit_supplier_payment_path(@supplier_payment)
  end

  def unsettled
    @supplier_payments = SupplierPayment.unsettled.paginate(:page => params[:page], :per_page => 50)
  end

  def add_auto_complete_purchase_order
     @supplier_payment = SupplierPayment.find(params[:id])
      errors = @supplier_payment.add_autocomplete_purchase_order(params[:supplier_payment])
        if errors.empty?
          flash[:notice] = "Supplier Payment was successfully added"
        else
           flash[:error] = errors
        end
    redirect_to item_new_page_supplier_payment_path(@supplier_payment)
  end

  def add_purchase_order
    @supplier_payment = SupplierPayment.find(params[:id])
   params[:item] ||= []
   if params[:item].any?
        errors = @supplier_payment.add_purchase_order(params[:item])
          if errors.empty?
            flash[:notice] = "Supplier Payment was successfully added"
          else
            flash[:error] = errors
          end
        if params[:commit] == "Add and Continue"
          redirect_to item_new_page_supplier_payment_path(@supplier_payment)
        elsif params[:commit] == "Add and Return"
         redirect_to edit_supplier_payment_path(@supplier_payment)
        end
   else
      flash[:error] = "must choose at least one item"
      redirect_to item_new_page_supplier_payment_path(@supplier_payment)
   end
  end

  def preview
    @supplier_payment = SupplierPayment.find(params[:id])
     @items = @supplier_payment.supplier_payment_items
     @settings = Setting.all
    render :layout => false
  end

  def item_new_page
    @supplier_payment = SupplierPayment.find(params[:id])
    @search = PurchaseOrder.unpaid.search(params[:search])
    @search.supplier_id_equals = @supplier_payment.supplier_id
    @purchase_orders = @search.order('Purchase_order_date DESC, created_at DESC').all.uniq.paginate(:page => params[:page], :per_page => 10)
    @items = @supplier_payment.supplier_payment_items

  end

  def removed_item
     @supplier_payment = SupplierPayment.find(params[:id])
      params[:item] ||= []
    if params[:item].any?
     @supplier_payment.remove_payment_item(params[:item])
    flash[:notice] = "Supplier Payment Item was successfully removed"
    else
      flash[:error] = "must choose at least one item"
    end
      redirect_to item_new_page_supplier_payment_path(@supplier_payment)
  end

  def add_supplier
    @search = Supplier.search(params[:search])
    @suppliers = @search.order('code ASC').all.uniq.paginate(:page => params[:page], :per_page => 20)
  end
  
  def check_payment_method
    if params[:payment_method_id].any?
      @payment = PaymentMethod.find(params[:payment_method_id])
    else
      @payment = PaymentMethod.first
    end
     
  end

  def show_payment_info
    payment = PaymentMethod.find(params[:payment_method_id]) if (params[:payment_method_id]) rescue nil
    if payment
    if payment.payment_name.include?("CHEQUE")
        page.show 'payment_info'
     else
        page.hide 'payment_info'
      end 
    end
  end

end


