class CustomerPaymentsController < ApplicationController
  before_filter :require_user
  # GET /customer_payments
  # GET /customer_payments.xml

  def index
    @search = CustomerPayment.search(params[:search])
    @customer_payments = @search.order('cust_payment_date DESC, created_at DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customer_payments }
    end
  end

  # GET /customer_payments/1
  # GET /customer_payments/1.xml
  def show
    @customer_payment = CustomerPayment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customer_payment }
    end
  end

  # GET /customer_payments/new
  # GET /customer_payments/new.xml
  def new
    @customer_payment = CustomerPayment.new
    @invoice = Invoice.unimported
    @customer_payment.cust_payment_date = Date.today
    @customer_payment.save!
    redirect_to edit_customer_payment_path(@customer_payment)
    
    
  end

  # GET /customer_payments/1/edit
  def edit
    @customer_payment = CustomerPayment.find(params[:id])
    
    @search = Invoice.unpaid.search(params[:search])
    @search.customer_id_equals = @customer_payment.customer_id
    @invoices = @search.all.uniq.paginate(:page => params[:page], :per_page => 10)  
    @items = @customer_payment.customer_payment_items
    @payment = PaymentMethod.all
  end

  # POST /customer_payments
  # POST /customer_payments.xml
   def create
     @customer_payment = CustomerPayment.new(params[:customer_payment])
    #if check_validation
      if @customer_payment.save
    redirect_to(edit_customer_payment_path(@customer_payment), :notice => 'customer payment was successfully created.')
      else
        render :action => "new"
      end

  end
  # PUT /customer_payments/1
  # PUT /customer_payments/1.xml
  def update
    @customer_payment = CustomerPayment.find(params[:id])

    respond_to do |format|
      if @customer_payment.update_attributes(params[:customer_payment])
        format.html { redirect_to(@customer_payment, :notice => 'Customer payment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer_payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def update_info
   @customer_payment = CustomerPayment.find(params[:id])
    if params[:commit] == "Add customer"
      if params[:customer_payment]
         found = @customer_payment.check_customer(params[:customer_payment])
         if found
            flash[:notice] = "customer payment was successfully updated"
        else
           flash[:error] = "Customer payment was unsuccessfully updated. Delete all the Invoice before change the customer"
        end
         redirect_to edit_customer_payment_path(@customer_payment)
     else
       flash[:error] = "Customer uncessfully added. Please check customer "
       redirect_to add_customer_customer_payment_path(@customer_payment)
     end
    elsif params[:commit] == "Update info"
       input = Date.parse(params[:customer_payment][:cust_payment_date])
         if input > Date.today
           flash[:error] = "Please select valid date "
        else
          if params[:customer_payment][:payment_method_id]== ""
                 @customer_payment.payment_method_id = nil
                 @customer_payment.cheque_number = nil
                 @customer_payment.bank = nil
                 @customer_payment.cheque_date = nil
                 @customer_payment.cust_payment_date = params[:customer_payment][:cust_payment_date]
                 @customer_payment.remark = params[:customer_payment][:remark]
                 @customer_payment.save!
           else
          found = @customer_payment.customer_payment(params[:customer_payment])
           flash[:notice] = "Customer Payment was successfully updated"
        end
         end
        redirect_to edit_customer_payment_path(@customer_payment)
   end
 end

  def update_invoice
   @customer_payment = CustomerPayment.find(params[:id])
    params[:item] ||= []
    if params[:commit] == "Update items"
      errors = @customer_payment.update_items(params[:item])
        if errors.empty?
          flash[:notice] = "Customer Payment Item was successfully updated"
        else
          flash[:error] = errors
        end
    elsif params[:commit] == "Remove items"
       errors = @customer_payment.remove_item(params[:item])
         if errors.empty?
          flash[:notice] =  "Customer Payment Item was successfully removed"
        else
          flash[:error] = errors
        end    
    end
    redirect_to edit_customer_payment_path(@customer_payment)
  end

  def settle
    @customer_payment = CustomerPayment.find(params[:id])
    if params[:status_id].to_i == 1
       @customer_payment.settled = true
       @customer_payment.save!
       flash[:notice] = "Customer Payment Item was successfully settled"
    elsif params[:status_id].to_i == 2
       @customer_payment.settled = false
       @customer_payment.save!
    end
    redirect_to edit_customer_payment_path(@customer_payment)
  end

   def unsettled
    @customer_payments = CustomerPayment.unsettled.paginate(:page => params[:page], :per_page => 50)
   end

  def post_payment
    @customer_payment = CustomerPayment.find(params[:id])
    result = @customer_payment.check_settle
       if result
        if @customer_payment.payment_paid
           @customer_payment.settled = true
           @customer_payment.save!
          flash[:notice] = "Customer Payment Item was successfully posted"
        else
          @customer_payment.settled = false
          @customer_payment.save!
          flash[:error] = "Customer Payment Item was successfully settled"
        end
      else
          flash[:error] = "Customer Payment unsucessfully to settle. Please complete the customer payment item "
      end
    redirect_to edit_customer_payment_path(@customer_payment)
  end

  def add_auto_complete_invoice  
     @customer_payment = CustomerPayment.find(params[:id])
        errors = @customer_payment.add_autocomplete_invoice(params[:customer_payment])
         if errors.empty?
          flash[:notice] = "Customer Payment Item was successfully added"
        else
           flash[:error] = errors
        end
   redirect_to item_new_page_customer_payment_path(@customer_payment)
  end

  def add_invoice
    @customer_payment = CustomerPayment.find(params[:id])
     params[:item] ||= []
    if params[:item].any?
      errors = @customer_payment.add_invoice(params[:item])
      if errors.empty?
        flash[:notice] = "Customer Payment Item was successfully Added"
      else
        flash[:error] = errors
     end
    if params[:commit] == "Add and Return"
     redirect_to edit_customer_payment_path(@customer_payment)
    elsif params[:commit] == "Add and Continue"
     redirect_to item_new_page_customer_payment_path(@customer_payment)
  end
    else
      flash[:error] = "must choose at least one item"
      redirect_to item_new_page_customer_payment_path(@customer_payment)
    end
   
  end
  



  # DELETE /customer_payments/1
  # DELETE /customer_payments/1.xml
  def destroy
    @customer_payment = CustomerPayment.find(params[:id])
    @customer_payment.voided = true
    @customer_payment.save!
    flash[:notice] = "Voided Successfully"

    respond_to do |format|
      format.html { redirect_to(customer_payments_url) }
      format.xml  { head :ok }
    end
  end
  def preview
    @customer_payment = CustomerPayment.find(params[:id])
     @items = @customer_payment.customer_payment_items
     @settings = Setting.all
    render :layout => false
  end

  def item_new_page
    @customer_payment = CustomerPayment.find(params[:id])
    @search = Invoice.unpaid.search(params[:search])
    @search.customer_id_equals = @customer_payment.customer_id
    @invoices = @search.order('invoice_number DESC, created_at DESC').all.uniq.paginate(:page => params[:page], :per_page => 10)
    @items = @customer_payment.customer_payment_items
  end

  def removed_item
     @customer_payment = CustomerPayment.find(params[:id])
     params[:item] ||= []
    if params[:item].any?
     @customer_payment.removed_payment_item(params[:item])
      flash[:notice] = "Customer Payment Item was successfully removed"
       else
      flash[:error] = "must choose at least one item"
    end
    redirect_to item_new_page_customer_payment_path(@customer_payment)
 end
 
 def add_customer
    @search = Customer.search(params[:search])
    @customers = @search.order('code ASC').all.uniq.paginate(:page => params[:page], :per_page => 20)
  end

  def check_payment_method
    if params[:payment_method_id].any?
      @payment = PaymentMethod.find(params[:payment_method_id])
    else
      @payment = PaymentMethod.first
    end
    
  end

  

end
