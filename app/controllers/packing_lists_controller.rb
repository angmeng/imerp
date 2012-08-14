class PackingListsController < ApplicationController
  before_filter :require_user
  # GET /packing_list
  # GET /packing_lists.xml
  def index
    @search = PackingList.search(params[:search])
    @packing_lists = @search.order('packing_list_date DESC, created_at DESC').order('packing_list_number DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @packing_lists }


    end
  end

  # GET /packing_listss/1
  # GET /packing_listss/1.xml
  def show
   
    @packing_list = PackingList.find(params[:id])

    @current_items = @packing_list.packing_list_items
    @mixed_items = MixedProduct.all
  
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @packing_list }
    end
  end
  
  def update_info
    @packing_list = PackingList.find(params[:id])
    @packing_list.update_attributes(params[:packing_list])
    flash[:notice] = "Picking List has been update"
    redirect_to @packing_list
  end

  # GET /packing_list/new
  # GET /packing_list/new.xml
  def new
    @packing_list = PackingList.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @packing_list }
    end
  end

  # GET /packing_list/1/edit
  def edit
    @packing_list = PackingList.find(params[:id])
  end

  # POST /packing_lists
  # POST /packing_lists.xml
  def create
    @packing_list = PackingList.new(params[:packing_list])

    respond_to do |format|
      if @packing_list.save
        format.html { redirect_to(@packing_list, :notice => 'Packing List was successfully created.') }
        format.xml  { render :xml => @packing_list, :status => :created, :location => @packing_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @packing_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /packing_list/1
  # PUT /packing_list/1.xml
  def update
    @packing_list = PackingList.find(params[:id])

    respond_to do |format|
      if @packing_list.update_attributes(params[:purchase_order])
        format.html { redirect_to(@packing_list, :notice => 'Packing List was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @packing_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /packing_list/1
  # DELETE /packing_list/1.xml
  def destroy
    @packing_list = PackingList.find(params[:id])
    @packing_list.verify_for_destroy
    flash[:notice] = "Packing List has been voided"
    respond_to do |format|
      format.html { redirect_to(packing_list_url) }
      format.xml  { head :ok }
    end
  end

  def preview
    @packing_list = PackingList.find(params[:id])
    @settings = Setting.all
    render :layout => false
  end
end
