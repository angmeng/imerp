class ProductDepartmentsController < ApplicationController
  before_filter :require_user
  # GET /product_departments
  # GET /product_departments.xml
  def index
    @product_departments = ProductDepartment.all.uniq.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_departments }
    end
  end

  # GET /product_departments/1
  # GET /product_departments/1.xml
  def show
    @product_department = ProductDepartment.find(params[:id])
    @products = Product.find_all_by_product_department_id(@product_department)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_department }
    end
  end

  # GET /product_departments/new
  # GET /product_departments/new.xml
  def new
    @product_department = ProductDepartment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_department }
    end
  end

  def new_department
    @product_department = ProductDepartment.new
    @product = Product.find(params[:id]) rescue nil
    render :layout => false
  end

  # GET /product_departments/1/edit
  def edit
    @product_department = ProductDepartment.find(params[:id])
  end

  # POST /product_departments
  # POST /product_departments.xml
  def create
    @product_department = ProductDepartment.new(params[:product_department])


     if @product_department.save
        if params[:product_id].to_i > 0
          @product = Product.find(params[:product_id].to_i)
          session[:product_department_id] = @product_department.id
          flash[:notice] = "Product Department was successfully created"
          redirect_to edit_product_path(@product)
       elsif params[:product_id].to_i == 0
          session[:product_department_id] = @product_department.id
          flash[:notice] = "Product Department was successfully created"
          redirect_to new_product_path
       else
          redirect_to(product_departments_path, :notice => 'Product Department was successfully created.')
       end
       else
        if params[:product_id].to_i > 0
          @product = Product.find(params[:product_id].to_i)
          flash[:error] = "Product Department was unsuccessfully created"
          redirect_to edit_product_path(@product)
       elsif params[:product_id].to_i == 0
          flash[:error] = "Product Department was unsuccessfully created"
          redirect_to new_product_path
       else
          render :action => "Product Department was unsuccessfully created"
        end

      end
  end

  # PUT /product_departments/1
  # PUT /product_departments/1.xml
  def update
    @product_department = ProductDepartment.find(params[:id])

    respond_to do |format|
      if @product_department.update_attributes(params[:product_department])
        format.html { redirect_to(edit_product_department_path(@product_department), :notice => 'Product department was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_department.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /product_departments/1
  # DELETE /product_departments/1.xml
  def destroy
    @product_department = ProductDepartment.find(params[:id])
    @product_department.destroy
    flash[:notice] = "Product department was successfully destroy"

    respond_to do |format|
      format.html { redirect_to(product_departments_url) }
      format.xml  { head :ok }
    end
  end
end
