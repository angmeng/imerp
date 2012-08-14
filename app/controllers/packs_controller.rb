class PacksController < ApplicationController
  # GET /packs
  # GET /packs.xml
  def index
    
    @search = Pack.search(params[:search])
    @packs = @search.order('pack_date DESC, created_at DESC').all.uniq.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @packs }
    end
  end

  # GET /packs/1
  # GET /packs/1.xml
  def show
    @pack = Pack.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pack }
    end
  end

  # GET /packs/new
  # GET /packs/new.xml
  def new
    @pack = Pack.new
    @pack.user_id = current_user.id
    @pack.pack_date = Date.today
    @pack.save!

   redirect_to edit_pack_path(@pack)
   
  end

  # GET /packs/1/edit
  def edit
    @pack = Pack.find(params[:id])
    @search = MixedProduct.search(params[:search])
    @products = @search.all.uniq.paginate(:page => params[:page], :per_page => 10)
  end

  # POST /packs
  # POST /packs.xml
  def create
    @pack = Pack.new(params[:pack])

     if @pack.save
        redirect_to(edit_pack_path(@pack), :notice => 'Product Mixed was successfully created.')
     else
        render :action => "new"
     end
  end

  # PUT /packs/1
  # PUT /packs/1.xml
  def update
    @pack = Pack.find(params[:id])

    respond_to do |format|
      if @pack.update_attributes(params[:pack])
        format.html { redirect_to(@pack, :notice => 'Product Mixed was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pack.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_info
    @pack = Pack.find(params[:id])
     input = Date.parse(params[:pack][:pack_date])
         if input > Date.today
           flash[:error] = "Please select valid date "
        else
           @pack.update_attributes(params[:pack])
          flash[:notice] = "Product Mixed was successfully updated"
         end
    redirect_to edit_pack_path(@pack)
  end

  def update_item
  @pack = Pack.find(params[:id])
    if params[:commit] == "Update items"
       errors = @pack.update_item(params[:item])
       if errors.empty?
            flash[:notice] = "Product Mixed was successfully updated"
       else
          flash[:error] = errors
       end
   elsif params[:commit] == "Remove items"
       @pack.remove_item(params[:item])
       flash[:notice] = "Product Mixed Item was successfully removed"
    end
    redirect_to edit_pack_path(@pack)
  end

  def item_new_page
   @pack = Pack.find(params[:id])
   

   @search = Product.search(params[:search])
   @search.product_kind_id_equals = ProductKind::MIXED
   @products = @search.all.paginate(:page => params[:page], :per_page => 10)
   
   
  end

  # DELETE /packs/1
  # DELETE /packs/1.xml
  def destroy
    @pack = Pack.find(params[:id])
    @pack.destroy

    respond_to do |format|
      format.html { redirect_to(packs_url) }
      format.xml  { head :ok }
    end
  end

  def add_item
    @pack = Pack.find(params[:id])
    errors = @pack.add_item(params[:item])
    if errors.empty?
      flash[:notice] = "Product Mixed Item was successfully Added"
    else
      flash[:error] = errors
    end
    if params[:commit] == "Add and Return"
      redirect_to edit_pack_path(@pack)
    elsif params[:commit] == "Add and Continue"
       redirect_to item_new_page_pack_path(@pack)
    end

  end

  def add_auto_complete_item
    @pack = Pack.find(params[:id])
       @pack.add_autocomplete_item(params[:pack])
        flash[:notice] = "Product Mixed Item was successfully Added"
    redirect_to item_new_page_pack_path(@pack)
  end

  def removed_item
    @pack = Pack.find(params[:id])
     params[:item] ||= []
    if params[:item].any?
     @pack.remove_item(params[:item])
      flash[:notice] = "Product Mixed was successfully removed"
   else
      flash[:error] = "must choose at least one item"
    end

   redirect_to item_new_page_pack_path(@pack)
 end

 def show_popup
     @product = Product.find(params[:id])
     @result = @product.collect_virtual_quantity
    render :layout => false
 end

  def post_quantity
    @pack = Pack.find(params[:id])
    @pack_item = @pack.pack_items
     if params[:commit] == "Confirm"
       result = @pack.check_settle
         if result
           pass = @pack.check_subitem
             if pass
              @pack.post_quantity
               flash[:notice] = "Mixed Product packing was successfully post quantity"
               redirect_to edit_pack_path(@pack)
             else
               flash[:error] = "Pack unsucessfully to settle. Please complete the pack subitem "
                redirect_to pack_subitem_pack_path(@pack_item)
        end
         else
              flash[:error] = "Pack unsucessfully to settle. Please complete the pack item "
              redirect_to edit_pack_path(@pack)
         end
    elsif params[:commit] == "Cancel"
      flash[:notice] = "Mixed Product packing was cancel"
      redirect_to edit_pack_path(@pack)
      
    end
    
    
  end

  def pack_subitem
     @pack_item = PackItem.find(params[:id])
     @pack_subitems = @pack_item.pack_item_subitems

 end

 def update_subitem
  @pack_item = PackItem.find(params[:id])
  @pack_item.update_subitem(params[:item])
     flash[:notice] = "Product Mixed was successfully updated"
     redirect_to pack_subitem_pack_path(@pack_item)
  end

 def confirm_post_quantity
    @pack = Pack.find(params[:id])
#    @pack_item = @pack.pack_items
#    @pack_item_subitems = @pack_item.pack_item_subitems

  end

 def preview
     @pack = Pack.find(params[:id])
     @settings = Setting.all
    render :layout => false

  end

end
