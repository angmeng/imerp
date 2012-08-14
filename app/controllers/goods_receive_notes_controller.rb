class GoodsReceiveNotesController < ApplicationController
  before_filter :require_user
  # GET /goods_receive_notes
  # GET /goods_receive_notes.xml
  def index
    @search = GoodsReceiveNote.search(params[:search])
    @goods_receive_notes = @search.order('grn_date DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @goods_receive_notes }
    end
  end

  # GET /goods_receive_notes/1
  # GET /goods_receive_notes/1.xml
  def show
    @goods_receive_note = GoodsReceiveNote.find(params[:id])
    @items = @goods_receive_note.goods_receive_note_items
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @goods_receive_note }
    end
  end

  # GET /goods_receive_notes/new
  # GET /goods_receive_notes/new.xml
  def new
    @goods_receive_note = GoodsReceiveNote.new
    @po = PurchaseOrder.unsettled.order('purchase_order_date DESC').order('created_at DESC')
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @goods_receive_note }
    end
  end

  # GET /goods_receive_notes/1/edit
  def edit
    @goods_receive_note = GoodsReceiveNote.find(params[:id])
    if @goods_receive_note.settled? or @goods_receive_note.voided?
      flash[:error] = "GRN has been closed for editing"
      redirect_to goods_receive_notes_url
    end
  end

  # POST /goods_receive_notes
  # POST /goods_receive_notes.xml
  def create
    @goods_receive_note = GoodsReceiveNote.new(params[:goods_receive_note])

    if params[:commit] == "Search"
      @po = PurchaseOrder.all(:conditions => ["purchase_order_number = ?", params[:po_number]])
      render :action => "new"
    else
      if params[:goods_receive_note] && params[:goods_receive_note][:purchase_order_id]
        @purchase_order = PurchaseOrder.find(params[:goods_receive_note][:purchase_order_id].to_i)
        if @purchase_order
          @items = @purchase_order.check_quantity
        else
          flash[:error] = "Select Purchase Order to Create GRN "
          @po = PurchaseOrder.unsettled
        end
        render :action => "new"
      else
        if params[:purchase_order_id]
          @goods_receive_note.purchase_order_id = params[:purchase_order_id].to_i
         input = Date.parse(params[:goods_receive_note][:grn_date])
         if input > Date.today
          flash[:error] = "Please select valid date "
           @po = PurchaseOrder.unsettled
          render :action => "new"
         else
          if @goods_receive_note.save
            params[:purchase_order_item] ||= []
            if params[:purchase_order_item].any?
              @goods_receive_note.import_items(params[:purchase_order_item])
              flash[:notice] = 'Goods Receive Note was successfully created.'
            else
              flash[:error] = "You must at least choose one PO"
            end
            redirect_to(@goods_receive_note)
          else
              @purchase_order = PurchaseOrder.find(params[:purchase_order_id].to_i) rescue nil
              if @purchase_order
                @items = @purchase_order.check_quantity
              else
                flash[:error] = "You  must at least choose one PO"
                @po = PurchaseOrder.unsettled
              end
              render :action => "new"
            end
            end
        else
         
          flash[:error] = "You  must at least choose one PO"
          @po = PurchaseOrder.unsettled
          render :action => "new"
        end
      end
     end

  end

  # PUT /goods_receive_notes/1
  # PUT /goods_receive_notes/1.xml
  def update
    @goods_receive_note = GoodsReceiveNote.find(params[:id])

    respond_to do |format|
      if @goods_receive_note.update_attributes(params[:goods_receive_note])
        format.html { redirect_to(@goods_receive_note, :notice => 'Goods Receive Note was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @goods_receive_note.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update_info
    @goods_receive_note = GoodsReceiveNote.find(params[:id])
     input = Date.parse(params[:goods_receive_note][:grn_date])
     if input > Date.today
       flash[:error] = "Please select valid date "
     else
      params[:goods_receive_note] ||= []
      @goods_receive_note.update_attributes(params[:goods_receive_note])
      flash[:notice] = "Goods Receive Note was successfully update "
     
  end
   redirect_to @goods_receive_note
  end

  # DELETE /goods_receive_notes/1
  # DELETE /goods_receive_notes/1.xml
  def update_items
     @goods_receive_note = GoodsReceiveNote.find(params[:id])
      params[:item] ||= []
        if params[:commit] == "Update Items"
            errors = @goods_receive_note.update_items(params[:item])
            if errors.empty?
                flash[:notice] = "Goods Receive Note Item was successfully update"
            else
                flash[:error] = errors
            end
         elsif params[:commit] == "Remove Items"
            @goods_receive_note.remove_item(params[:item])
            flash[:notice] = "Goods Receive Note Item was successfully removed"
        end
    redirect_to @goods_receive_note
  end

  def settle
    @goods_receive_note = GoodsReceiveNote.find(params[:id])
    if params[:status_id].to_i == 1
     
      if @goods_receive_note.verify_settle
          flash[:notice] = "Goods Receive Note Item was successfully  settled"
      else
          flash[:error] = "GRN was unsuccessfully to settled. Please fill the GRN item in valid value"
      end
   
    elsif params[:status_id].to_i == 2
      @goods_receive_note.settled = false
      @goods_receive_note.save!
    end
    redirect_to @goods_receive_note
  end

  def remove_item
    item = GoodsReceiveNoteItem.find(params[:id])
    @goods_receive_note = item.goods_receive_note
    item.destroy
    flash[:notice] = "Goods Receive Note Item was successfully removed"
    redirect_to @goods_receive_note
  end

  # DELETE /outlet_goods_receive_notes/1
  # DELETE /outlet_goods_receive_notes/1.xml
  def destroy
  @goods_receive_note = GoodsReceiveNote.find(params[:id])
    if @goods_receive_note.voided?
      flash[:error] = "GRN has already been voided before"
    else
      passed, msg = @goods_receive_note.verify_destroy
      if passed
        flash[:notice] = msg
      else
        flash[:error] = msg
      end
    end

    respond_to do |format|
      format.html { redirect_back_or_default(goods_receive_notes_url) }
      format.xml  { head :ok }
    end
  end

  def show_items
    @goods_receive_note = GoodsReceiveNote.find(params[:id])
    @purchase_order = @goods_receive_note.purchase_order
    @items = @purchase_order.check_quantity

  end

  def import_items
    @goods_receive_note = GoodsReceiveNote.find(params[:id])
    @goods_receive_note.import_items(params[:purchase_order_item] ||= [])
    flash[:notice] = "Goods Receive Note Item was successfully imported"
    redirect_to @goods_receive_note
  end

  def settle_po
    @goods_receive_note = GoodsReceiveNote.find(params[:id])
    po = @goods_receive_note.purchase_order
    po.imported = true
    po.save!
    flash[:notice] = "Goods Receive Note Item was successfully settled"
    redirect_to @goods_receive_note
  end

  def unsettle_po
    @goods_receive_note = GoodsReceiveNote.find(params[:id])
    po = @goods_receive_note.purchase_order
    po.imported = false
    po.save!
    flash[:notice] = "Goods Receive Note Item was successfully unsettled"
    redirect_to @goods_receive_note
  end



  def unsettled
    @goods_receive_notes = GoodsReceiveNote.unsettled.paginate(:page => params[:page], :per_page => 50)
  end

  def show_settled_po
    @po = PurchaseOrder.had_settled.all.paginate(:page => params[:page], :per_page => 50)
  end

  def edit_remark
    @item = GoodsReceiveNoteItem.find(params[:id])
    @goods_receive_note = @item.goods_receive_note
  end

  def update_remark
    @goods_receive_note = GoodsReceiveNote.find(params[:id])
    params[:item].each do |item_id, content|
      item = @goods_receive_note.goods_receive_note_items.find(item_id.to_i)
      item.remark = content[:remark]
      item.save!
    end
    flash[:notice] = "Goods Receive Note was successfully update"
    redirect_to @goods_receive_note
  end

  def preview
    @goods_receive_note = GoodsReceiveNote.find(params[:id])
    @items = @goods_receive_note.goods_receive_note_items
    @settings = Setting.all
    render :layout => false
  end
end
