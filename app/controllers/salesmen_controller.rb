class SalesmenController < ApplicationController
  # GET /salesmen
  # GET /salesmen.xml
  def index
    @search = Salesman.search(params[:search])
    @salesmens = @search.all.uniq.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @salesmen }
    end
  end

  # GET /salesmen/1
  # GET /salesmen/1.xml
  def show
    @salesman = Salesman.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @salesman }
    end
  end

  # GET /salesmen/new
  # GET /salesmen/new.xml
  def new
    @salesman = Salesman.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @salesman }
    end
  end

  # GET /salesmen/1/edit
  def edit
    @salesman = Salesman.find(params[:id])
  end

  # POST /salesmen
  # POST /salesmen.xml
  def create
    @salesman = Salesman.new(params[:salesman])

    respond_to do |format|
      if @salesman.save
        format.html { redirect_to(@salesman, :notice => 'Salesman was successfully created.') }
        format.xml  { render :xml => @salesman, :status => :created, :location => @salesman }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @salesman.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /salesmen/1
  # PUT /salesmen/1.xml
  def update
    @salesman = Salesman.find(params[:id])

    respond_to do |format|
      if @salesman.update_attributes(params[:salesman])
        format.html { redirect_to(@salesman, :notice => 'Salesman was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @salesman.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /salesmen/1
  # DELETE /salesmen/1.xml
  def destroy
    @salesman = Salesman.find(params[:id])
    @salesman.destroy

    respond_to do |format|
      format.html { redirect_to(salesmen_url) }
      format.xml  { head :ok }
    end
  end
end
