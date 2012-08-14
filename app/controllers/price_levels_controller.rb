class PriceLevelsController < ApplicationController
  before_filter :require_user
  # GET /price_levels
  # GET /price_levels.xml
  def index
    @price_levels = PriceLevel.all.uniq.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @price_levels }
    end
  end

  # GET /price_levels/1
  # GET /price_levels/1.xml
  def show
    @price_level = PriceLevel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @price_level }
    end
  end

  # GET /price_levels/new
  # GET /price_levels/new.xml
  def new
    @price_level = PriceLevel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @price_level }
    end
  end

  # GET /price_levels/1/edit
  def edit
    @price_level = PriceLevel.find(params[:id])
  end

  # POST /price_levels
  # POST /price_levels.xml
  def create
    @price_level = PriceLevel.new(params[:price_level])

    respond_to do |format|
      if @price_level.save
        format.html { redirect_to(price_levels_path, :notice => 'Price level was successfully created.') }
        format.xml  { render :xml => @price_level, :status => :created, :location => @price_level }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @price_level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /price_levels/1
  # PUT /price_levels/1.xml
  def update
    @price_level = PriceLevel.find(params[:id])

    respond_to do |format|
      if @price_level.update_attributes(params[:price_level])
        format.html { redirect_to(edit_price_level_path(@price_level), :notice => 'Price level was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @price_level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /price_levels/1
  # DELETE /price_levels/1.xml
  def destroy
    @price_level = PriceLevel.find(params[:id])
    @price_level.destroy

    respond_to do |format|
      format.html { redirect_to(price_levels_url) }
      format.xml  { head :ok }
    end
  end
end
