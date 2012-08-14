class PackItemsController < ApplicationController
  # GET /pack_items
  # GET /pack_items.xml
  def index
    @pack_items = PackItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pack_items }
    end
  end

  # GET /pack_items/1
  # GET /pack_items/1.xml
  def show
    @pack_item = PackItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pack_item }
    end
  end

  # GET /pack_items/new
  # GET /pack_items/new.xml
  def new
    @pack_item = PackItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pack_item }
    end
  end

  # GET /pack_items/1/edit
  def edit
    @pack_item = PackItem.find(params[:id])
  end

  # POST /pack_items
  # POST /pack_items.xml
  def create
    @pack_item = PackItem.new(params[:pack_item])

    respond_to do |format|
      if @pack_item.save
        format.html { redirect_to(@pack_item, :notice => 'Pack item was successfully created.') }
        format.xml  { render :xml => @pack_item, :status => :created, :location => @pack_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pack_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pack_items/1
  # PUT /pack_items/1.xml
  def update
    @pack_item = PackItem.find(params[:id])

    respond_to do |format|
      if @pack_item.update_attributes(params[:pack_item])
        format.html { redirect_to(@pack_item, :notice => 'Pack item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pack_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pack_items/1
  # DELETE /pack_items/1.xml
  def destroy
    @pack_item = PackItem.find(params[:id])
    @pack_item.destroy

    respond_to do |format|
      format.html { redirect_to(pack_items_url) }
      format.xml  { head :ok }
    end
  end
end
