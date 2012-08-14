class ProductKindsController < ApplicationController
  before_filter :require_user
  # GET /product_kinds
  # GET /product_kinds.xml
  def index
    @product_kinds = ProductKind.all.uniq.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_kinds }
    end
  end

  # GET /product_kinds/1
  # GET /product_kinds/1.xml
  def show
    @product_kind = ProductKind.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_kind }
    end
  end

  # GET /product_kinds/new
  # GET /product_kinds/new.xml
  def new
    @product_kind = ProductKind.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_kind }
    end
  end

  def new_kind
    @product_kind = ProductKind.new
     @product = Product.find(params[:id])rescue nil
    render :layout => false
  end

  # GET /product_kinds/1/edit
  def edit
    @product_kind = ProductKind.find(params[:id])
  end

  # POST /product_kinds
  # POST /product_kinds.xml
  def create
    @product_kind = ProductKind.new(params[:product_kind])
    if @product_kind.save
       if params[:product_id].to_i > 0
          @product = Product.find(params[:product_id].to_i)
          session[:product_kind_id] = @product_kind.id
           flash[:notice] = "Product Type was successfully created"
          redirect_to edit_product_path(@product)
       elsif params[:product_id].to_i == 0
          session[:product_kind_id] = @product_kind.id
           flash[:notice] = "Product Type was successfully created"
          redirect_to new_product_path
       else
          redirect_to(product_kinds_path, :notice => 'Product Type was successfully created.')
        end
      else
        if params[:product_id].to_i > 0
          @product = Product.find(params[:product_id].to_i)
          flash[:error] = "Product Type was unsuccessfully created"
          redirect_to edit_product_path(@product)
       elsif params[:product_id].to_i == 0
          flash[:error] = "Product Type was unsuccessfully created"
          redirect_to new_product_path
       else
          render :action => "Product Type was unsuccessfully created"
        end
        
      end
  end

  # PUT /product_kinds/1
  # PUT /product_kinds/1.xml
  def update
    @product_kind = ProductKind.find(params[:id])

    respond_to do |format|
      if @product_kind.update_attributes(params[:product_kind])
        format.html { redirect_to(edit_product_kind_path(@product_kind), :notice => 'Product kind was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_kind.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /product_kinds/1
  # DELETE /product_kinds/1.xml
  def destroy
    @product_kind = ProductKind.find(params[:id])
    check = @product_kind.verify_destroy
    
    if check
      flash[:notice] = "Sucessfully removed"
    else
      flash[:error] = "The record is System built-in, cannot be delete."
    end
    
    respond_to do |format|
      format.html { redirect_to(product_kinds_url) }
      format.xml  { head :ok }
    end
  end
end
