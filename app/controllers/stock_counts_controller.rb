class StockCountsController < ApplicationController
  before_filter :require_user
  # GET /stock_counts
  # GET /stock_counts.xml
  def index
    @stock_counts = StockCount.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stock_counts }
    end
  end

  # GET /stock_counts/1
  # GET /stock_counts/1.xml
  def show
    @stock_count = StockCount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stock_count }
    end
  end

  # GET /stock_counts/new
  # GET /stock_counts/new.xml
  def new
    @stock_count = StockCount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stock_count }
    end
  end

  # GET /stock_counts/1/edit
  def edit
    @stock_count = StockCount.find(params[:id])
  end

  # POST /stock_counts
  # POST /stock_counts.xml
  def create
    @stock_count = StockCount.new(params[:stock_count])

    respond_to do |format|
      if @stock_count.save
        format.html { redirect_to(@stock_count, :notice => 'Stock count was successfully created.') }
        format.xml  { render :xml => @stock_count, :status => :created, :location => @stock_count }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stock_count.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stock_counts/1
  # PUT /stock_counts/1.xml
  def update
    @stock_count = StockCount.find(params[:id])

    respond_to do |format|
      if @stock_count.update_attributes(params[:stock_count])
        format.html { redirect_to(@stock_count, :notice => 'Stock count was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stock_count.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_counts/1
  # DELETE /stock_counts/1.xml
  def destroy
    @stock_count = StockCount.find(params[:id])
    @stock_count.destroy

    respond_to do |format|
      format.html { redirect_to(stock_counts_url) }
      format.xml  { head :ok }
    end
  end
end
