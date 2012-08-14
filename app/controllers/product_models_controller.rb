class ProductModelsController < ApplicationController
  before_filter :require_user
  # GET /product_models
  # GET /product_models.xml
  def index
    @product_models = ProductModel.all.uniq.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_models }
    end
  end

  # GET /product_models/1
  # GET /product_models/1.xml
  def show
    @product_model = ProductModel.find(params[:id])
    @products = Product.find_all_by_product_model_id(@product_model)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_model }
    end
  end

  # GET /product_models/new
  # GET /product_models/new.xml
  def new
    @product_model = ProductModel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_model }
    end
  end

  def new_model
    @product_model = ProductModel.new
    @product = Product.find(params[:id]) rescue nil
    render :layout => false
  end

  # GET /product_models/1/edit
  def edit
    @product_model = ProductModel.find(params[:id])
  end

  # POST /product_models
  # POST /product_models.xml
  def create
    @product_model = ProductModel.new(params[:product_model])
    if @product_model.save
       if params[:product_id].to_i > 0
          @product = Product.find(params[:product_id].to_i)
          session[:product_model_id] = @product_model.id
          flash[:notice] = "Product Model was successfully created"
          redirect_to edit_product_path(@product)
       elsif params[:product_id].to_i == 0
          session[:product_model_id] = @product_model.id
          flash[:notice] = "Product Model was successfully created"
          redirect_to new_product_path
       else
          redirect_to(product_models_path, :notice => 'Product Model was successfully created.')
        end
       else
        if params[:product_id].to_i > 0
          @product = Product.find(params[:product_id].to_i)
          flash[:error] = "Product Model was unsuccessfully created"
          redirect_to edit_product_path(@product)
       elsif params[:product_id].to_i == 0
          flash[:error] = "error"
          redirect_to new_product_path
       else
          render :action => "Product Model was unsuccessfully created"
        end

      end
  end

  # PUT /product_models/1
  # PUT /product_models/1.xml
  def update
    @product_model = ProductModel.find(params[:id])

    respond_to do |format|
      if @product_model.update_attributes(params[:product_model])
        format.html { redirect_to(edit_product_model_path(@product_model), :notice => 'Product model was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /product_models/1
  # DELETE /product_models/1.xml
  def destroy
    @product_model = ProductModel.find(params[:id])
    @product_model.destroy
    flash[:notice] = "Product model was successfully destroy"

    respond_to do |format|
      format.html { redirect_to(product_models_url) }
      format.xml  { head :ok }
    end
  end
end
