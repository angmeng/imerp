class SalesOrdersController < ApplicationController
  before_filter :require_user
  # GET /sales_orders
  # GET /sales_orders.xml
 

  def index
    @search = SalesOrder.search(params[:search])
    @sales_orders = @search.order('sales_order_date DESC , created_at DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)

  end

  # GET /sales_orders/1
  # GET /sales_orders/1.xml
  def show
    @sales_order = SalesOrder.find(params[:id])
  end

  # GET /sales_orders/new
  # GET /sales_orders/new.xml
  def new
    @sales_order = SalesOrder.new
    @sales_order.customer_id = 0
    @sales_order.sales_order_date = Date.today
    @sales_order.issued_user_id = current_user.id
    @sales_order.save!
    session[:customer] = 0

    redirect_to edit_sales_order_path(@sales_order)
  end

  # GET /sales_orders/1/edit
  def edit
    @sales_order = SalesOrder.find(params[:id])
    @customers = Customer.order("code").map {|c| [c.code_name, c.id]}
    session[:customer] = 0
    
  end

  
  # POST /sales_orders
  # POST /sales_orders.xml
  def create
    @sales_order = SalesOrder.new(params[:sales_order])
    #if check_validation
      if @sales_order.save
        #@sales_order.add_item(params[:item])
        redirect_to(edit_sales_order_path(@sales_order), :notice => 'Sales Order was successfully created.')
      else
        render :action => "new"
      end
    #else
    #  initial_data
    #  flash[:error] = "Please fill in the item information"
    #  render :action => "new"
    #end
  end

  # PUT /sales_orders/1
  # PUT /sales_orders/1.xml
  def update
    @sales_order = SalesOrder.find(params[:id])

    respond_to do |format|
      if @sales_order.update_attributes(params[:sales_order])
        format.html { redirect_to(@sales_order, :notice => 'Sales Order was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sales_order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_orders/1
  # DELETE /sales_orders/1.xml
  def destroy
    @sales_order = SalesOrder.find(params[:id])
    if @sales_order.verify_for_destroy
      flash[:notice] = "Successfully Voided"
    else
      flash[:error] = "Error!!"
    end
    redirect_back_or_default(sales_orders_url)
  end
  
  def void
    @sales_order = SalesOrder.find(params[:id])
    @sales_order.void = true
    @sales_order.save!
    flash[:notice] = "Sales Order was successfully voided"
    redirect_back_or_default sales_orders_url
  end

  def remove_item
    item = SalesOrderItem.find(params[:id])
    item.destroy
    flash[:notice] = "Sales Order Item was successfully removed"
    redirect_to edit_sales_order_path(item.sales_order)
  end

  def update_info
    @sales_order = SalesOrder.find(params[:id])
    if params[:commit] == "Add customer"
        if params[:sales_order]
         @sales_order.update_attributes(params[:sales_order])
         flash[:notice] = "Sales Order was successfully updated"
           redirect_to edit_sales_order_path(@sales_order)
       else
         flash[:error] = "Customer uncessfully added. Please check customer "
         redirect_to add_customer_sales_order_path(@sales_order)
       end
    elsif params[:commit] == "Update info"
        input = Date.parse(params[:sales_order][:sales_order_date])
        if input > Date.today
            flash[:error] = "Please select valid date "
        else
            @sales_order.update_attributes(params[:sales_order])
            flash[:notice] = "Sales Order Item was successfully update"
        end
        redirect_to edit_sales_order_path(@sales_order)
  end
  end

  def update_item
    @sales_order = SalesOrder.find(params[:id])
     if params[:commit] == "Update Items"
        @sales_order.salesman_id = params[:sales_order][:salesman_id] if params[:sales_order][:salesman_id]
          @sales_order.save!
          errors = @sales_order.update_item(params[:item])
          if errors.empty?
              flash[:notice] = "Sales Order Item was successfully updated"
          else
              flash[:error] = errors
          end
     elsif params[:commit] == "Confirm Items"
        check = @sales_order.check_settle
        if check
         @sales_order.confirm_item(params[:item])
          flash[:notice] = "Sales Order Item was successfully confirmed"
        else
           flash[:error] = "Sales Order unsucessfully confirm. Please fill the SO item in valid value"
        end
     elsif params[:commit] == "Remove Items"
       @sales_order.remove_item(params[:item])
      flash[:notice] = "Sales Order Item was successfully removed"
    else
      flash[:error] = "must choose at least one item"
    end
    
    redirect_to edit_sales_order_path(@sales_order)
    end
     
 


  def add_item
    @sales_order = SalesOrder.find(params[:id])
    
      errors = @sales_order.add_item(params[:item])
       if errors.empty?
         flash[:notice] = "Sales Order Item was successfully added"
       else
         flash[:error] = errors
       end
       if params[:commit] == "Add and Return"
          redirect_to edit_sales_order_path(@sales_order)
       elsif params[:commit] == "Add and Continue"
          redirect_to item_new_page_sales_order_path(@sales_order)
       end
  
 end


  def add_auto_complete_item
    @sales_order = SalesOrder.find(params[:id])
    errors = @sales_order.add_autocomplete_item(params[:sales_order])
    if errors.empty?
      flash[:notice] = "Sales Order Item was successfully added"
    else
         flash[:error] = errors
    end
   redirect_to item_new_page_sales_order_path(@sales_order)
  end
  

  def item_new_page
   @sales_order = SalesOrder.find(params[:id])
   @search = Product.search(params[:search])
   @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 10)
    if session[:customer].to_i > 0
     @customer = Customer.find(session[:customer])
   end
  end
  
  

  def send_for_approval
    @sales_order = SalesOrder.find(params[:id])
     pass = @sales_order.check_settle
       if pass
         if @sales_order.send_for_approval
          flash[:notice] = "Sales Order was successfully sent for approval"
         else
          flash[:error] = "The sales order does not have any confirmed item or Salesman not assigned"
         end
       else
         flash[:error] = "Sales Order unsucessfully send for approval. Please fill the SO item in in valid value"
       end
    redirect_to edit_sales_order_path(@sales_order)
  end

  def approve
    @sales_order = SalesOrder.find(params[:id])
      pass = @sales_order.check_settle
       if pass
          if @sales_order.approve(current_user.id)
            @sales_order.generate_po
            flash[:notice] = "Sales Order was successfully approved"
          else
            flash[:error] = "Sales Order cannot be approved. You might not have any confirmed item or invalid SO information."
          end
       else
         flash[:error] = "Sales Order unsucessfully approved. Please fill the SO item in valid value"
       end
    redirect_to edit_sales_order_path(@sales_order)
  end

  def regenerate_so
    @sales_order = SalesOrder.find(params[:id])
    @sales_order.regenerate_po
    flash[:notice] = "Packing List regenerated"
    redirect_to edit_sales_order_path(@sales_order)
  end

  def preview
    @sales_order = SalesOrder.find(params[:id])
    @settings = Setting.all
    render :layout => false
  end


   

 def show_popup
     @product = Product.find(params[:id])
     @result = @product.collect_virtual_quantity
    render :layout => false
 end

  def add_customer
    @search = Customer.search(params[:search])
    @customers = @search.order('code ASC').all.uniq.paginate(:page => params[:page], :per_page => 20)
  end

  def session_customer
     @sales_order = SalesOrder.find(params[:id])

    if params[:customer]
        customer = Customer.find(params[:customer])
        session[:customer] = customer.id
        redirect_to item_new_page_sales_order_path(@sales_order)
     else
       session[:customer] = 0
       flash[:error] = "Customer uncessfully added. Please check Customer "
       redirect_to add_customer_sales_order_path(@sales_order)
    end
    
  end

 def removed_item
    @sales_order = SalesOrder.find(params[:id])
    params[:item] ||= []
    if params[:item].any?
      @sales_order.removed_so_item(params[:item])
      flash[:notice] = "Sales Order Item was successfully removed"
    else
      flash[:error] = "must choose at least one item"
    end
   redirect_to item_new_page_sales_order_path(@sales_order)
 end


  private

 def find_uom
    @uom = ProductUom.find(params[:id])
 end
  def initial_data
    @customers = Customer.order("code").map {|c| [c.code_name, c.id]}
    @products = Product.order("code").map {|c| [c.code_name, c.id]}
  end

  def check_validation
    checked = true
    if params[:item][:product_id] and params[:item][:customer_id]
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
