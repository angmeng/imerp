class ProductCategoriesController < ApplicationController
  before_filter :require_user
  # GET /product_categories
  # GET /product_categories.xml
  def index
    @product_categories = ProductCategory.all.uniq.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_categories }
    end
  end

  # GET /product_categories/1
  # GET /product_categories/1.xml
  def show
    @product_category = ProductCategory.find(params[:id])
    @products = Product.find_all_by_product_category_id(@product_category)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_category }
    end
  end

  # GET /product_categories/new
  # GET /product_categories/new.xml
  def new
    @product_category = ProductCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_category }
    end
  end

  def new_category
    @product_category = ProductCategory.new
    @product = Product.find(params[:id])rescue nil
    render :layout => false
  end


  # GET /product_categories/1/edit
  def edit
    @product_category = ProductCategory.find(params[:id])
  end

  # POST /product_categories
  # POST /product_categories.xml
  def create
    @product_category = ProductCategory.new(params[:product_category])

     if @product_category.save
         if params[:product_id].to_i > 0
          @product = Product.find(params[:product_id].to_i)
          session[:product_category_id] = @product_category.id
           flash[:notice] = "Product Category was successfully created"
          redirect_to edit_product_path(@product)
       elsif params[:product_id].to_i == 0
          session[:product_category_id] = @product_category.id
           flash[:notice] = "Product Category was successfully created"
          redirect_to new_product_path
        else
          redirect_to(product_categories_path, :notice => 'Product Category was successfully created.')
        end
   else
        if params[:product_id].to_i > 0
          @product = Product.find(params[:product_id].to_i)
          flash[:error] = "Product Category was unsuccessfully created"
          redirect_to edit_product_path(@product)
       elsif params[:product_id].to_i == 0
          flash[:error] = "Product Category was unsuccessfully created"
          redirect_to new_product_path
       else
          render :action => "Product Category was unsuccessfully created"
        end

      end
  end


  # PUT /product_categories/1
  # PUT /product_categories/1.xml
  def update
    @product_category = ProductCategory.find(params[:id])

    respond_to do |format|
      if @product_category.update_attributes(params[:product_category])
        format.html { redirect_to(edit_product_category_path(@product_category), :notice => 'Product category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /product_categories/1
  # DELETE /product_categories/1.xml
  def destroy
    @product_category = ProductCategory.find(params[:id])
    @product_category.destroy

    respond_to do |format|
      format.html { redirect_to(product_categories_url) }
      format.xml  { head :ok }
    end
  end
end
