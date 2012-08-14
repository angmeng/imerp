class ProductBrandsController < ApplicationController
  before_filter :require_user
  # GET /product_brands
  # GET /product_brands.xml
  def index
    @product_brands = ProductBrand.all.uniq.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_brands }
    end
  end

  # GET /product_brands/1
  # GET /product_brands/1.xml
  def show
    @product_brand = ProductBrand.find(params[:id])
    @products = Product.find_all_by_product_brand_id(@product_brand)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_brand }
    end
  end

  # GET /product_brands/new
  # GET /product_brands/new.xml
  def new
    @product_brand = ProductBrand.new
   respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_brand }
    end
  end

  def new_brand
    @product_brand = ProductBrand.new
    @product = Product.find(params[:id]) rescue nil
    render :layout => false
  end

  # GET /product_brands/1/edit
  def edit
    @product_brand = ProductBrand.find(params[:id])
  end

  # POST /product_brands
  # POST /product_brands.xml
  def create
    @product_brand = ProductBrand.new(params[:product_brand])
     if @product_brand.save
       if params[:product_id].to_i > 0
          @product = Product.find(params[:product_id].to_i)
          session[:product_brand_id] = @product_brand.id
           flash[:notice] = "Product brand was successfully created"
          redirect_to edit_product_path(@product)
       elsif params[:product_id].to_i == 0
          session[:product_brand_id] = @product_brand.id
           flash[:notice] = "Product brand was successfully created"
          redirect_to new_product_path(@product)
       else
          redirect_to(product_brands_path, :notice => 'Product brand was successfully created.')
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
  # PUT /product_brands/1
  # PUT /product_brands/1.xml
  def update
    @product_brand = ProductBrand.find(params[:id])

    respond_to do |format|
      if @product_brand.update_attributes(params[:product_brand])
        format.html { redirect_to(product_brands_path(@product_brand), :notice => 'Product brand was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_brand.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show_popup
     @product = Product.find(params[:id])
     @result = @product.collect_virtual_quantity
      render :layout => false
 end


  # DELETE /product_brands/1
  # DELETE /product_brands/1.xml
  def destroy
    @product_brand = ProductBrand.find(params[:id])
    @product_brand.destroy
    flash[:notice] = "Product brand was successfully destroy"
    respond_to do |format|
      format.html { redirect_to(product_brands_url) }
      format.xml  { head :ok }
    end
  end
end
