Ssh::Application.routes.draw do
  
  

 

 

  resources :payment_methods

  resources :pack_item_subitems

  resources :pack_items

  resources :packs do
    member do
      post   'update_info'
      post   'update_item'
      get    'item_new_page'
      post   'removed_item'
      get    'show_popup'
      post   'add_item'
      post   'removed_item'
      post   'post_quantity'
      get    'pack_subitem'
      post   'add_auto_complete_item'
      post   'update_subitem'
      get    'confirm_post_quantity'
      get    'preview'
    end
  end

  resources :cities

  resources :salesmen

  resources :transports

  resources :stock_disposals do
    collection do
      get 'unsettled'
    end
    member do
      post 'update_info'
      delete 'remove_item'
      post   'add_item'
      post   'update_item'
      post   'add_auto_complete_product'
      get    'preview'
      get    'post_quantity'
      get    'show_popup'
      get    'settle'
      get    'post_quantity'
      get    'item_new_page'
      post   'removed_item'
    end
  end

  resources :stock_transfers do
    collection do
      get 'unsettled'
    end
    member do
      post   'update_info'
      delete 'remove_item'
      post   'add_item'
      post   'update_item'
      post   'add_auto_complete_product'
      get    'preview'
      get    'post_quantity'
      get    'show_popup'
      get    'settle'
      get    'post_quantity'
      get    'item_new_page'
      post   'removed_item'
    end
  end

  resources :stock_adjustments do
    collection do
      get 'unsettled'
    end
    member do
      post 'update_info'
      delete 'remove_item'
      post   'add_item'
      post   'update_item'
      post   'add_auto_complete_stock'
      get    'preview'
      get    'post_quantity'
      get    'show_popup'
      get    'settle'
      get    'post_quantity'
      get    'item_new_page'
      post   'removed_item'
      
    end
  end
  
  resources :supplier_payments do
   collection do
      get 'unsettled'
      post 'check_payment_method'
    end
    member do
      post   'update_info'
      delete 'remove_item'
      post   'add_purchase_order'
      post   'update_purchase_order'
      post   'add_auto_complete_purchase_order'
      get    'preview'
      get    'settle'
      get    'post_payment'
      get    'item_new_page'
      post   'removed_item'
      get   'add_supplier'
      get    'payment_details'
    
    end
  end

  resources :customer_payments do
    collection do
      get 'unsettled'
      post 'check_payment_method'
    end
    member do
      get    'post_payment'
      post   'update_info'
      delete 'remove_item'
      post   'add_invoice'
      post   'update_invoice'
      post   'add_auto_complete_invoice'
      get    'preview'
      get    'settle'
      get    'post_payment'
      get    'item_new_page'
      post   'removed_item'
      get    'add_customer'
      get    'payment_details'
    end
  end
  

  resources :supplier_debit_notes do
    collection do
      get 'unsettled'
    end
    member do
      post   'update_info'
      delete 'remove_item'
      post   'add_item'
      post   'update_item'
      post   'add_auto_complete_item'
      get    'preview'
      get    'post_quantity'
      get    'show_popup'
      get    'settle'
      get    'post_quantity'
      get    'item_new_page'
      post   'removed_item'
       get   'add_supplier'
    end
  end

  resources :supplier_credit_notes do
    collection do
      get 'unsettled'
    end
    member do
      post   'update_info'
      delete 'remove_item'
      post   'add_item'
      post   'update_item'
      post   'add_auto_complete_item'
      get    'preview'
      get    'post_quantity'
      get    'show_popup'
      get    'settle'
      get    'post_quantity'
      get    'item_new_page'
      post   'removed_item'
       get   'add_supplier'
    end
  end

  resources :customer_debit_notes do
    collection do
      get 'unsettled'
    end
    member do
      post   'update_info'
      delete 'remove_item'
      post   'add_item'
      post   'update_item'
      post   'add_auto_complete_item'
      get    'preview'
      get    'post_quantity'
      get    'show_popup'
      get    'settle'
      get    'post_quantity'
      get    'item_new_page'
      post   'removed_item'
      get   'add_customer'
    end
  end

  resources :customer_credit_notes do
    collection do
      get 'unsettled'
    end
    member do
      post   'update_info'
      delete 'remove_item'
      post   'add_item'
      post   'update_item'
      post   'add_auto_complete_item'
      get    'preview'
      get    'post_quantity'
      get    'show_popup'
      get    'settle'
      get    'post_quantity'
      get    'item_new_page'
      post   'removed_item'
      get   'add_customer'
    end
  end

  resources :delivery_orders do
    collection do
      get 'unsettled'
      get  'query'
      get  'show_settled_packing_list'
    end
    member do
      get  'show_items'
      post 'update_info'
      get  'settle_po'
      get  'unsettle_po'
      get  'settle'
      post 'update_items'
      get  'remove_item'
      post 'import_items'
      get  'preview'
      get  'post_quantity'
     
    end
  end

  resources :packing_lists do
    member do
      post 'update_info'
      get  'preview'
    end
  end

  resources :sales_orders do
    collection do

    end
    member do
      post   'update_info'
       get    'show_popup'
      delete 'remove_item'
      post   'add_item'
      post   'add_item'
      get    'item_new_page'
      post   'update_item'
      post   'removed_item'
      get    'preview'
      get    'send_for_approval'
      get    'approve'
      get    'regenerate_so'
      post   'add_auto_complete_item'
      get   'add_customer'
      post   'session_customer'
    end
  end

  resources :customers

  resources :goods_receive_notes do
    collection do
      get 'unsettled'
      get 'show_settled_po'
    end
    member do
      get  'show_items'
      get  'settle_po'
      get  'unsettle_po'
      get  'settle'
      post 'update_items'
      post 'update_info'
      get  'remove_item'
      post 'import_items'
      get  'preview'
      get  'post_quantity'
      get   'add_supplier'
    end
  end

  resources :purchase_orders do
    collection do
      get 'unsettled'
    end
    member do
      post 'update_info'
      get  'preview'  
    end
    collection do
    get  'query'
   end
  end

  resources :suppliers

  resources :purchase_requisitions do
    member do
      post 'update_info'
      delete 'remove_item'
      post   'add_item'
      post   'update_item'
      get    'preview'
      get    'send_for_approval'
      get    'approve'
      get    'regenerate_po'
      post   'add_auto_complete_item'
      get    'show_popup'
      post   'add_supplier'
       get    'item_new_page'
      post   'removed_item'
      get   'add_supplier'
      post  'session_supplier'
    end

  end

  resources :invoices do
    collection do
      get 'unsettled'
       get  'query'
    end
    member do
      post 'update_info'
      post 'add_delivery_order'
      get  'preview'
      get  'item_new_page'
      post 'update_do'
      post 'removed_do'
      post 'add_auto_complete_delivery_order'
      get   'add_customer'
      get 'settle'
      
    end
   
  end

  resources :mixed_products do
    member do
      get  'show_products'
      post 'update_quantity'
      post 'add_products'
    end
  end

  resources :stock_counts

  resources :product_pricings

  resources :settings

  resources :price_levels

  resources :stock_locations do
    member do
      get  'show_opening_balance'
      post 'update_balance'
   
    end
  end

  resources :product_racks do
     collection do
     end
    member do
      get  'show_stocks'
      get  'new_stocks'
      post 'add_item'
      post 'add_stocks'
      post 'remove_stocks'
      post 'add_auto_complete_item'
      get  'item_new_page'
      post 'removed_item'
      post 'delete_item'
      get  'edit_rack'
      get  'add_all'
      get  'add_uoms'
      get  'new_rack'

    end
  end

  resources :product_locations do
    member do
      get 'show_racks'
    end
  end

  resources :product_serial_numbers

  resources :product_uoms do
    member do
      get 'show_pricings'
      delete 'remove_item'
      post 'update_pricings'
    end
  end
  
  resources :products do
    collection do
      get 'virtual_movement'
      get 'product_movement'
      get  'query'
    end
    member do
      post 'update_uoms' 
      post 'auto_complete_product'
      get  'show_popup'
      get  'show_onhand'
      post 'add_uoms'
      get  'add_location'
      post 'remove_rack'
      post 'add_product'
      get  'new_brand'
      post 'add_brand'
      get  'mixed_product'
      post 'update_info'
end
  end

  resources :product_kinds do
    member do
      get 'new_kind'
    end
  end

  resources :product_models do
   member do
   get    'show_popup'
   get    'new_model'
   end
  end
  resources :product_departments do
   member do
   get    'show_popup'
   get    'new_department'
   end
  end
  resources :product_brands do
   member do
   get    'show_popup'
   get    'new_brand'
 end
  end
  resources :product_categories do
    member do
      get 'new_category'
    end
  end

  resources :departments do
    member do
      get 'new_department'
    end
  end

  resources :users
  
  resources :user_sessions


  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "user_sessions#new"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
