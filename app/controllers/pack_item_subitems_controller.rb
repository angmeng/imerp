class PackItemSubitemsController < ApplicationController
  # GET /pack_item_subitems
  # GET /pack_item_subitems.xml
  def index
    @pack_item_subitems = PackItemSubitem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pack_item_subitems }
    end
  end

  # GET /pack_item_subitems/1
  # GET /pack_item_subitems/1.xml
  def show
    @pack_item_subitem = PackItemSubitem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pack_item_subitem }
    end
  end

  # GET /pack_item_subitems/new
  # GET /pack_item_subitems/new.xml
  def new
    @pack_item_subitem = PackItemSubitem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pack_item_subitem }
    end
  end

  # GET /pack_item_subitems/1/edit
  def edit
    @pack_item_subitem = PackItemSubitem.find(params[:id])
  end

  # POST /pack_item_subitems
  # POST /pack_item_subitems.xml
  def create
    @pack_item_subitem = PackItemSubitem.new(params[:pack_item_subitem])

    respond_to do |format|
      if @pack_item_subitem.save
        format.html { redirect_to(@pack_item_subitem, :notice => 'Pack item subitem was successfully created.') }
        format.xml  { render :xml => @pack_item_subitem, :status => :created, :location => @pack_item_subitem }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pack_item_subitem.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pack_item_subitems/1
  # PUT /pack_item_subitems/1.xml
  def update
    @pack_item_subitem = PackItemSubitem.find(params[:id])

    respond_to do |format|
      if @pack_item_subitem.update_attributes(params[:pack_item_subitem])
        format.html { redirect_to(@pack_item_subitem, :notice => 'Pack item subitem was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pack_item_subitem.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pack_item_subitems/1
  # DELETE /pack_item_subitems/1.xml
  def destroy
    @pack_item_subitem = PackItemSubitem.find(params[:id])
    @pack_item_subitem.destroy

    respond_to do |format|
      format.html { redirect_to(pack_item_subitems_url) }
      format.xml  { head :ok }
    end
  end
end
