class DeliveryOrdersController < ApplicationController
  before_filter :require_user
  # GET /delivery_orders
  # GET /delivery_orders.xml
  def index
    @search = DeliveryOrder.search(params[:search])
    @delivery_orders = @search.order('delivery_order_date DESC, created_at DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @delivery_orders }
    end
  end

  # GET /delivery_orders/1
  # GET /delivery_orders/1.xml
  def show
    @delivery_order = DeliveryOrder.find(params[:id])
    @items = @delivery_order.delivery_order_items
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @delivery_order }
    end
  end

  def query
   @delivery_orders = DeliveryOrder.settled.where("name LIKE ?", "%#{params[:q]}%")

    respond_to do |format|
      format.html
      format.xml  { render :xml => @delivery_orders }
      format.json { render :json => @delivery_orders.map(&:attributes)}
    end
  end

  # GET /delivery_orders/new
  # GET /delivery_orders/new.xml
  def new
    @delivery_order = DeliveryOrder.new
    @po = PackingList.unimported.order('packing_list_date DESC').order('created_at DESC')
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @delivery_order }
    end
  end

  # GET /delivery_orders/1/edit
  def edit
    @delivery_order = DeliveryOrder.find(params[:id])
    if @delivery_order.settled? or @delivery_order.voided?
      flash[:error] = "DO has been closed for editing"
      redirect_to delivery_orders_url
    end
  end

  # POST /delivery_orders
  # POST /delivery_orders.xml
  def create
   @delivery_order = DeliveryOrder.new(params[:delivery_order])

    if params[:commit] == "Search"
      @po = PackingList.all(:conditions => ["packing_list_number = ?", params[:po_number]])
      render :action => "new"
    else
      if params[:delivery_order] && params[:delivery_order][:packing_list_id]
        @packing_list = PackingList.find(params[:delivery_order][:packing_list_id].to_i) rescue nil
        if @packing_list
          @items = @packing_list.check_quantity
        else
          flash[:error] = "You  must at least choose one picking list"
          @po = PackingList.unimported.order('packing_list_date DESC, created_at DESC')
        end
        render :action => "new"
      else
          if params[:packing_list_id]
            @delivery_order.packing_list_id = params[:packing_list_id].to_i
            input = Date.parse(params[:delivery_order][:delivery_order_date])
          if input > Date.today
          flash[:error] = "Please select valid date "
           @po = PackingList.unimported.order('packing_list_date DESC, created_at DESC')
          render :action => "new"
         else
          if @delivery_order.save
              params[:packing_list_item] ||= []
              if params[:packing_list_item].any?
                @delivery_order.import_items(params[:packing_list_item])
                flash[:notice] = 'Delivery Order was successfully created.'
              else
                flash[:error] = "You must at least choose one Picking list"
              end
              redirect_to(@delivery_order)
            else
              @packing_list = PackingList.find(params[:packing_list_id].to_i) rescue nil
              if @packing_list
                @items = @packing_list.check_quantity
              else
                flash[:error] = "You  must at least choose one picking list"
                @po = PackingList.unimported.order('packing_list_date DESC, created_at DESC')
              end
              render :action => "new"
            end
          end
          else
            flash[:error] = "You  must at least choose one picking list"
            @po = PackingList.unimported
            render :action => "new"
          end
        end
      end
    end


  # PUT /delivery_orders/1
  # PUT /delivery_orders/1.xml
  def update
   @delivery_order = DeliveryOrder.find(params[:id])
  
   input = Date.parse(params[:delivery_order][:delivery_order_date])
   if input > Date.today
     flash[:error] = "Please select valid date "
   else
    respond_to do |format|
      if @delivery_order.update_attributes(params[:delivery_order])
        format.html { redirect_to(@delivery_order, :notice => 'Delivery Order was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @delivery_order.errors, :status => :unprocessable_entity }
      end
    end
  end
  end
  def update_info
    @delivery_order = DeliveryOrder.find(params[:id])

    input = Date.parse(params[:delivery_order][:delivery_order_date])
    if input > Date.today 
      flash[:error] = "Please select valid date "
    else
      @delivery_order.update_attributes(params[:delivery_order])
      flash[:notice] = "Delivery Order was successfully updated"
      
    end
    redirect_to @delivery_order
  end

  # DELETE /delivery_orders/1
  # DELETE /delivery_orders/1.xml

  def update_items
    @delivery_order = DeliveryOrder.find(params[:id])
    params[:item] ||= []
     if params[:commit] == "Update Items"
      errors = @delivery_order.update_items(params[:item], params[:delivery_order][:transport_id])
        if errors.empty?
            flash[:notice] = "Delivery Order Item was successfully updated"
        else
            flash[:error] = errors
        end
     elsif params[:commit] == "Remove Items"
       @delivery_order.remove_item(params[:item])
        flash[:notice] = "Delivery Order Item was successfully removed"
     end
    redirect_to @delivery_order
  end

  def settle
    @delivery_order = DeliveryOrder.find(params[:id])
    if params[:status_id].to_i == 1
      if @delivery_order.verify_settle
        flash[:notice] = "Delivery Order was successfully settled"
      else
        flash[:error] = "Delivery Order was unsuccessfully to settled. Please complete the DO item in valid value"
      end
   
    elsif params[:status_id].to_i == 2
      @delivery_order.settled = false
      @delivery_order.save!
    end
    redirect_to @delivery_order
  end

  def remove_item
    item = DeliveryOrderItem.find(params[:id])
    @delivery_order = item.delivery_order
    item.destroy
    flash[:notice] = "Delivery Order Item was successfully removed"
    redirect_to @delivery_order
  end

  # DELETE /outlet_delivery_order/1
  # DELETE /outlet_delivery_orders/1.xml
  def destroy
  @delivery_order = DeliveryOrder.find(params[:id])
    if @delivery_order.voided?
      flash[:error] = "Delivery Order has already been voided before"
    else
      passed, msg = @delivery_order.verify_destroy
      if passed
        flash[:notice] = msg
      else
        flash[:error] = msg
      end
    end

    respond_to do |format|
      format.html { redirect_back_or_default(delivery_orders_url) }
      format.xml  { head :ok }
    end
  end

  def show_items
    @delivery_order = DeliveryOrder.find(params[:id])
    @packing_list = @delivery_order.packing_list
    @items = @packing_list.check_quantity
  end

  def import_items
    @delivery_order = DeliveryOrder.find(params[:id])
    params[:packing_list_item] ||= []
    if params[:packing_list_item].any?
      @delivery_order.import_items(params[:packing_list_item])
      flash[:notice] = "Delivery Order was successfully imported"
    else
      flash[:error] = "You must choose at least one Picking list"
    end
    redirect_to @delivery_order
  end

  def settle_po
   @delivery_order = DeliveryOrder.find(params[:id])
    po = @delivery_order.packing_list
    po.imported = true
    po.save!
    flash[:notice] = "Picking list marked as settled Completed"
    redirect_to @delivery_order
  end

  def unsettle_po
  @delivery_order = DeliveryOrder.find(params[:id])
    po = @delivery_order.packing_list
    po.imported = false
    po.save!
    flash[:notice] = "Picking list marked as unsettled Completed"
    redirect_to @delivery_order
  end

  def show_settled_packing_list
    @po = PackingList.had_settled.all.paginate(:page => params[:page], :per_page => 50)
  end

  def unsettled
    @delivery_orders = DeliveryOrder.unsettled.paginate(:page => params[:page], :per_page => 50)
  end

  def edit_remark
    @item = DeliveryOrder.find(params[:id])
    @delivery_order = @item.delivery_order
  end

  def update_remark
   @delivery_order = DeliveryOrder.find(params[:id])
    params[:item].each do |item_id, content|
      item = @delivery_order.delivery_orders.find(item_id.to_i)
      item.remark = content[:remark]
      item.save!
    end
    flash[:notice] = "Delivery Order was successfully updated "
    redirect_to @delivery_order
  end

  def preview
    @delivery_order = DeliveryOrder.find(params[:id])
    @items = @delivery_order.delivery_order_items
    @settings = Setting.all
    render :layout => false
  end

 

end
