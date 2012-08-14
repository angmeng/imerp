# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110725045826) do

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_credit_note_items", :force => true do |t|
    t.integer  "customer_credit_note_id",                                :default => 0
    t.integer  "product_id",                                             :default => 0
    t.integer  "product_uom_id",                                         :default => 0
    t.integer  "quantity",                                               :default => 0
    t.decimal  "unit_price",              :precision => 12, :scale => 2, :default => 0.0
    t.string   "remark"
    t.boolean  "posted",                                                 :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock_location_id"
  end

  add_index "customer_credit_note_items", ["customer_credit_note_id"], :name => "index_customer_credit_note_items_on_customer_credit_note_id"
  add_index "customer_credit_note_items", ["product_id"], :name => "index_customer_credit_note_items_on_product_id"
  add_index "customer_credit_note_items", ["product_uom_id"], :name => "index_customer_credit_note_items_on_product_uom_id"
  add_index "customer_credit_note_items", ["stock_location_id"], :name => "index_customer_credit_note_items_on_stock_location_id"

  create_table "customer_credit_notes", :force => true do |t|
    t.string   "cust_credit_note_number", :limit => 20
    t.date     "cust_credit_note_date"
    t.string   "remark"
    t.boolean  "voided",                                :default => false
    t.boolean  "posted",                                :default => false
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "settled",                               :default => false
  end

  add_index "customer_credit_notes", ["settled"], :name => "index_customer_credit_notes_on_settled"

  create_table "customer_debit_note_items", :force => true do |t|
    t.integer  "customer_debit_note_id",                                :default => 0
    t.integer  "product_id",                                            :default => 0
    t.integer  "product_uom_id",                                        :default => 0
    t.integer  "quantity",                                              :default => 0
    t.decimal  "unit_price",             :precision => 12, :scale => 2, :default => 0.0
    t.string   "remark"
    t.boolean  "posted",                                                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock_location_id"
  end

  add_index "customer_debit_note_items", ["customer_debit_note_id"], :name => "index_customer_debit_note_items_on_customer_debit_note_id"
  add_index "customer_debit_note_items", ["product_id"], :name => "index_customer_debit_note_items_on_product_id"
  add_index "customer_debit_note_items", ["product_uom_id"], :name => "index_customer_debit_note_items_on_product_uom_id"
  add_index "customer_debit_note_items", ["stock_location_id"], :name => "index_customer_debit_note_items_on_stock_location_id"

  create_table "customer_debit_notes", :force => true do |t|
    t.string   "cust_debit_note_number", :limit => 20
    t.date     "cust_debit_note_date"
    t.string   "remark"
    t.boolean  "voided",                               :default => false
    t.boolean  "posted",                               :default => false
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "settled",                              :default => false
  end

  add_index "customer_debit_notes", ["settled"], :name => "index_customer_debit_notes_on_settled"

  create_table "customer_payment_items", :force => true do |t|
    t.integer  "customer_payment_id",                                :default => 0
    t.integer  "invoice_id",                                         :default => 0
    t.decimal  "amount",              :precision => 12, :scale => 2, :default => 0.0
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "paid_amount",         :precision => 12, :scale => 2, :default => 0.0
  end

  create_table "customer_payments", :force => true do |t|
    t.string   "cust_payment_number", :limit => 20
    t.date     "cust_payment_date"
    t.string   "remark"
    t.boolean  "voided",                            :default => false
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "posted",                            :default => false
    t.boolean  "settled",                           :default => false
    t.integer  "payment_method_id"
    t.date     "cheque_date"
    t.string   "cheque_number"
    t.string   "bank"
  end

  add_index "customer_payments", ["payment_method_id"], :name => "index_customer_payments_on_payment_method_id"
  add_index "customer_payments", ["posted"], :name => "index_customer_payments_on_posted"
  add_index "customer_payments", ["settled"], :name => "index_customer_payments_on_sattled"

  create_table "customers", :force => true do |t|
    t.string   "code",            :limit => 45
    t.string   "name",            :limit => 45
    t.string   "company_number",  :limit => 20
    t.text     "address"
    t.string   "city",            :limit => 45
    t.string   "postcode",        :limit => 20
    t.string   "email",           :limit => 45
    t.string   "office_contact",  :limit => 45
    t.string   "office_contact2", :limit => 20
    t.string   "fax_number",      :limit => 20
    t.string   "contact_person",  :limit => 45
    t.string   "contact_number",  :limit => 20
    t.string   "term",            :limit => 45
    t.string   "remark"
    t.boolean  "suspend",                                                      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_level_id"
    t.decimal  "use_limit",                     :precision => 10, :scale => 0
    t.decimal  "credit_limit",                  :precision => 10, :scale => 0
    t.integer  "city_id"
  end

  add_index "customers", ["city_id"], :name => "index_customers_on_city_id"
  add_index "customers", ["code"], :name => "index_customers_on_code"
  add_index "customers", ["credit_limit"], :name => "index_customers_on_credit_limit"
  add_index "customers", ["price_level_id"], :name => "index_customers_on_price_level_id"
  add_index "customers", ["use_limit"], :name => "index_customers_on_use_limit"

  create_table "delivery_order_items", :force => true do |t|
    t.integer  "delivery_order_id",                                                 :default => 0
    t.integer  "product_id",                                                        :default => 0
    t.integer  "product_uom_id",                                                    :default => 0
    t.integer  "quantity",                                                          :default => 0
    t.decimal  "unit_price",                         :precision => 12, :scale => 2, :default => 0.0
    t.integer  "delivered_quantity",                                                :default => 0
    t.string   "remark"
    t.integer  "stock_location_id",                                                 :default => 0
    t.boolean  "settled",                                                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "packing_list_item_id",                                              :default => 0
    t.boolean  "posted",                                                            :default => false
    t.string   "discounts",            :limit => 45
  end

  add_index "delivery_order_items", ["discounts"], :name => "index_delivery_order_items_on_discounts"
  add_index "delivery_order_items", ["posted"], :name => "index_delivery_order_items_on_posted"

  create_table "delivery_orders", :force => true do |t|
    t.date     "delivery_order_date"
    t.string   "delivery_order_number"
    t.string   "purchase_order_number"
    t.string   "remark"
    t.boolean  "voided",                :default => false
    t.boolean  "settled",               :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id",           :default => 0
    t.integer  "packing_list_id",       :default => 0
    t.boolean  "starred",               :default => false
    t.boolean  "imported",              :default => false
    t.boolean  "posted",                :default => false
    t.string   "name"
    t.integer  "transport_id"
    t.integer  "salesman_id"
  end

  add_index "delivery_orders", ["name"], :name => "index_delivery_orders_on_name"
  add_index "delivery_orders", ["posted"], :name => "index_delivery_orders_on_posted"
  add_index "delivery_orders", ["salesman_id"], :name => "index_delivery_orders_on_salesman_id"
  add_index "delivery_orders", ["transport_id"], :name => "index_delivery_orders_on_transport_id"

  create_table "departments", :force => true do |t|
    t.string   "name",        :limit => 45, :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goods_receive_note_items", :force => true do |t|
    t.integer  "goods_receive_note_id",                                 :default => 0
    t.integer  "product_id",                                            :default => 0
    t.integer  "product_uom_id",                                        :default => 0
    t.integer  "quantity",                                              :default => 0
    t.decimal  "unit_price",             :precision => 12, :scale => 2, :default => 0.0
    t.integer  "purchase_order_item_id",                                :default => 0
    t.integer  "delivered_quantity",                                    :default => 0
    t.string   "remark"
    t.integer  "stock_location_id",                                     :default => 0
    t.boolean  "settled",                                               :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "posted",                                                :default => false
  end

  add_index "goods_receive_note_items", ["goods_receive_note_id"], :name => "index_goods_receive_note_items_on_goods_receive_note_id"
  add_index "goods_receive_note_items", ["posted"], :name => "index_goods_receive_note_items_on_posted"
  add_index "goods_receive_note_items", ["product_id"], :name => "index_goods_receive_note_items_on_product_id"
  add_index "goods_receive_note_items", ["product_uom_id"], :name => "index_goods_receive_note_items_on_product_uom_id"
  add_index "goods_receive_note_items", ["purchase_order_item_id"], :name => "index_goods_receive_note_items_on_purchase_order_item_id"
  add_index "goods_receive_note_items", ["settled"], :name => "index_goods_receive_note_items_on_settled"
  add_index "goods_receive_note_items", ["stock_location_id"], :name => "index_goods_receive_note_items_on_stock_location_id"

  create_table "goods_receive_notes", :force => true do |t|
    t.date     "grn_date"
    t.string   "grn_number",        :limit => 20
    t.string   "do_number",         :limit => 20
    t.string   "invoice_number",    :limit => 20
    t.string   "serial_number",     :limit => 20
    t.string   "remark"
    t.integer  "supplier_id",                     :default => 0
    t.integer  "purchase_order_id",               :default => 0
    t.boolean  "voided",                          :default => false
    t.boolean  "settled",                         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "posted",                          :default => false
    t.boolean  "void",                            :default => false
  end

  add_index "goods_receive_notes", ["posted"], :name => "index_goods_receive_notes_on_posted"
  add_index "goods_receive_notes", ["purchase_order_id"], :name => "index_goods_receive_notes_on_purchase_order_id"
  add_index "goods_receive_notes", ["settled"], :name => "index_goods_receive_notes_on_settled"
  add_index "goods_receive_notes", ["supplier_id"], :name => "index_goods_receive_notes_on_supplier_id"
  add_index "goods_receive_notes", ["void"], :name => "index_goods_receive_notes_on_void"
  add_index "goods_receive_notes", ["voided"], :name => "index_goods_receive_notes_on_voided"

  create_table "invoice_items", :force => true do |t|
    t.integer  "invoice_id",                                       :default => 0
    t.integer  "delivery_order_id",                                :default => 0
    t.decimal  "amount",            :precision => 12, :scale => 2, :default => 0.0
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", :force => true do |t|
    t.date     "invoice_date"
    t.string   "invoice_number",   :limit => 20
    t.integer  "customer_id",                    :default => 0
    t.string   "term",             :limit => 45
    t.string   "remark"
    t.integer  "sales_order_id",                 :default => 0
    t.boolean  "voided",                         :default => false
    t.boolean  "settled",                        :default => false
    t.boolean  "imported",                       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "end_invoice_date"
    t.string   "name"
    t.boolean  "payment_paid",                   :default => false
  end

  add_index "invoices", ["customer_id"], :name => "index_invoices_on_customer_id"
  add_index "invoices", ["imported"], :name => "index_invoices_on_imported"
  add_index "invoices", ["name"], :name => "index_invoices_on_name"
  add_index "invoices", ["payment_paid"], :name => "index_invoices_on_payment_paid"
  add_index "invoices", ["sales_order_id"], :name => "index_invoices_on_sales_order_id"
  add_index "invoices", ["settled"], :name => "index_invoices_on_settled"
  add_index "invoices", ["voided"], :name => "index_invoices_on_voided"

  create_table "mixed_products", :force => true do |t|
    t.integer  "parent_id",                     :null => false
    t.integer  "product_id",                    :null => false
    t.integer  "quantity",       :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_uom_id", :default => 0
    t.integer  "parent_uom_id"
  end

  add_index "mixed_products", ["parent_id"], :name => "index_mixed_products_on_parent_id"
  add_index "mixed_products", ["parent_uom_id"], :name => "index_mixed_products_on_parent_uom_id"
  add_index "mixed_products", ["product_id"], :name => "index_mixed_products_on_product_id"
  add_index "mixed_products", ["product_uom_id"], :name => "index_mixed_products_on_product_uom_id"

  create_table "pack_item_subitems", :force => true do |t|
    t.integer  "pack_item_id"
    t.integer  "product_id"
    t.integer  "product_uom_id"
    t.integer  "stock_location_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "cost",              :precision => 12, :scale => 3, :default => 0.0
  end

  add_index "pack_item_subitems", ["pack_item_id"], :name => "index_pack_item_subitems_on_pack_item_id"
  add_index "pack_item_subitems", ["product_id"], :name => "index_pack_item_subitems_on_product_id"
  add_index "pack_item_subitems", ["product_uom_id"], :name => "index_pack_item_subitems_on_product_uom_id"
  add_index "pack_item_subitems", ["stock_location_id"], :name => "index_pack_item_subitems_on_stock_location_id"

  create_table "pack_items", :force => true do |t|
    t.integer  "pack_id"
    t.integer  "product_id"
    t.integer  "product_uom_id"
    t.integer  "stock_location_id"
    t.integer  "quantity"
    t.decimal  "cost",              :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "posted",                                           :default => false
    t.boolean  "packing",                                          :default => true
  end

  create_table "packing_list_items", :force => true do |t|
    t.integer  "packing_list_id"
    t.integer  "sales_order_item_id"
    t.integer  "quantity"
    t.integer  "product_id"
    t.decimal  "unit_price",                        :precision => 12, :scale => 2, :default => 0.0
    t.string   "remark"
    t.string   "product_uom_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "discounts",           :limit => 45
  end

  add_index "packing_list_items", ["discounts"], :name => "index_packing_list_items_on_discounts"

  create_table "packing_lists", :force => true do |t|
    t.date     "packing_list_date"
    t.string   "packing_list_number"
    t.string   "term"
    t.string   "remark"
    t.boolean  "voided",              :default => false
    t.boolean  "settled",             :default => false
    t.boolean  "imported",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
    t.integer  "sales_order_id"
    t.boolean  "starred",             :default => false
    t.integer  "salesman_id"
  end

  add_index "packing_lists", ["salesman_id"], :name => "index_packing_lists_on_salesman_id"

  create_table "packs", :force => true do |t|
    t.date     "pack_date"
    t.string   "pack_number", :limit => 20
    t.integer  "user_id"
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "posted",                    :default => false
    t.boolean  "packing",                   :default => true
  end

  add_index "packs", ["user_id"], :name => "index_packs_on_user_id"

  create_table "payment_methods", :force => true do |t|
    t.string   "payment_name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "check",        :default => false
  end

  add_index "payment_methods", ["check"], :name => "index_payment_methods_on_check"

  create_table "price_levels", :force => true do |t|
    t.string   "name",        :limit => 45,                    :null => false
    t.text     "description"
    t.boolean  "disabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "built_in",                  :default => false
  end

  create_table "product_brands", :force => true do |t|
    t.string   "name",        :limit => 45,                    :null => false
    t.text     "description"
    t.boolean  "disabled",                  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_categories", :force => true do |t|
    t.string   "name",        :limit => 45,                    :null => false
    t.text     "description"
    t.boolean  "disabled",                  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_costings", :force => true do |t|
    t.integer  "product_id",                                                     :null => false
    t.integer  "product_uom_id",                                                 :null => false
    t.integer  "quantity",                                      :default => 0
    t.decimal  "cost",           :precision => 10, :scale => 3, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_costings", ["product_id"], :name => "index_product_costings_on_product_id"
  add_index "product_costings", ["product_uom_id"], :name => "index_product_costings_on_product_uom_id"

  create_table "product_departments", :force => true do |t|
    t.string   "name",        :limit => 45,                    :null => false
    t.text     "description"
    t.boolean  "disabled",                  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_kinds", :force => true do |t|
    t.string   "name",        :limit => 45,                    :null => false
    t.text     "description"
    t.boolean  "disabled",                  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_locations", :force => true do |t|
    t.string   "name",        :limit => 45,                    :null => false
    t.text     "description"
    t.boolean  "disabled",                  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_models", :force => true do |t|
    t.string   "name",        :limit => 45,                    :null => false
    t.text     "description"
    t.boolean  "disabled",                  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_movements", :force => true do |t|
    t.date     "movement_date"
    t.integer  "movement_id"
    t.integer  "product_id"
    t.integer  "product_uom_id"
    t.integer  "stock_location_id",                                :default => 0
    t.integer  "quantity"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "mixed",                                            :default => false
    t.string   "movement_type"
    t.decimal  "cost",              :precision => 12, :scale => 3, :default => 0.0
  end

  add_index "product_movements", ["mixed"], :name => "index_product_movements_on_mixed"
  add_index "product_movements", ["product_id"], :name => "index_product_movements_on_product_id"
  add_index "product_movements", ["product_uom_id"], :name => "index_product_movements_on_product_uom_id"
  add_index "product_movements", ["stock_location_id"], :name => "index_product_movements_on_stock_location_id"

  create_table "product_pricings", :force => true do |t|
    t.integer  "product_uom_item_id",                                                 :null => false
    t.integer  "price_level_id",                                                      :null => false
    t.decimal  "selling_price",       :precision => 12, :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "product_uom_id"
  end

  add_index "product_pricings", ["price_level_id"], :name => "index_product_pricings_on_price_level_id"
  add_index "product_pricings", ["product_id"], :name => "index_product_pricings_on_product_id"
  add_index "product_pricings", ["product_uom_id"], :name => "index_product_pricings_on_product_uom_id"
  add_index "product_pricings", ["product_uom_item_id"], :name => "index_product_pricings_on_product_uom_item_id"

  create_table "product_racks", :force => true do |t|
    t.integer  "product_location_id",                                  :null => false
    t.string   "name",                :limit => 45,                    :null => false
    t.text     "description"
    t.boolean  "disabled",                          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_racks", ["product_location_id"], :name => "index_product_racks_on_product_location_id"

  create_table "product_uom_items", :force => true do |t|
    t.integer  "product_uom_id",                                                                         :null => false
    t.integer  "product_id",                                                                             :null => false
    t.string   "barcode",                :limit => 45
    t.decimal  "conversion",                           :precision => 12, :scale => 2, :default => 1.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "fixed_cost",                           :precision => 12, :scale => 3, :default => 0.0
    t.decimal  "minimum_selling_price",                :precision => 12, :scale => 3, :default => 0.0
    t.decimal  "maximum_purchase_price",               :precision => 12, :scale => 3, :default => 0.0
    t.boolean  "default_uom",                                                         :default => false
  end

  add_index "product_uom_items", ["product_id"], :name => "index_product_uom_items_on_product_id"
  add_index "product_uom_items", ["product_uom_id"], :name => "index_product_uom_items_on_product_uom_id"

  create_table "product_uoms", :force => true do |t|
    t.string   "name",        :limit => 45,                    :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "builtin",                   :default => false
    t.boolean  "min_uom",                   :default => false
  end

  add_index "product_uoms", ["builtin"], :name => "index_product_uoms_on_default"
  add_index "product_uoms", ["min_uom"], :name => "index_product_uoms_on_min_uom"

  create_table "product_virtual_movements", :force => true do |t|
    t.date     "movement_date"
    t.integer  "virtual_movement_id"
    t.string   "virtual_movement_type"
    t.string   "description"
    t.integer  "product_id"
    t.integer  "product_uom_id"
    t.integer  "stock_location_id"
    t.integer  "quantity"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "mixed",                 :default => false
  end

  add_index "product_virtual_movements", ["mixed"], :name => "index_product_virtual_movements_on_mixed"
  add_index "product_virtual_movements", ["product_id"], :name => "index_product_virtual_movements_on_product_id"
  add_index "product_virtual_movements", ["product_uom_id"], :name => "index_product_virtual_movements_on_product_uom_id"
  add_index "product_virtual_movements", ["stock_location_id"], :name => "index_product_virtual_movements_on_stock_location_id"
  add_index "product_virtual_movements", ["user_id"], :name => "index_product_virtual_movements_on_user_id"
  add_index "product_virtual_movements", ["virtual_movement_id"], :name => "index_product_virtual_movements_on_virtual_movement_id"

  create_table "products", :force => true do |t|
    t.string   "code",                        :limit => 45,                    :null => false
    t.text     "full_description"
    t.string   "short_description",           :limit => 45
    t.integer  "product_kind_id",                                              :null => false
    t.integer  "product_category_id",                       :default => 0
    t.integer  "product_brand_id",                          :default => 0
    t.integer  "product_department_id",                     :default => 0
    t.integer  "product_model_id",                          :default => 0
    t.boolean  "is_stock",                                  :default => true
    t.boolean  "is_sales",                                  :default => true
    t.boolean  "is_open_item",                              :default => false
    t.boolean  "is_taxable",                                :default => false
    t.boolean  "is_disposal",                               :default => false
    t.boolean  "has_serial_no",                             :default => false
    t.boolean  "allow_discount_below_cost",                 :default => false
    t.boolean  "allow_negative_amount",                     :default => false
    t.boolean  "allow_quantity_discount",                   :default => false
    t.boolean  "allow_free_of_charge",                      :default => false
    t.boolean  "allow_zero_selling_price",                  :default => false
    t.boolean  "allow_zero_purchase_price",                 :default => false
    t.boolean  "allow_sales_discount",                      :default => false
    t.boolean  "allow_return_to_vendor",                    :default => false
    t.boolean  "cost_include_freight_charge",               :default => false
    t.boolean  "cost_include_insurance",                    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "in_house_code",               :limit => 13,                    :null => false
    t.boolean  "disabled",                                  :default => false
    t.boolean  "deleted",                                   :default => false
    t.boolean  "starred",                                   :default => false
    t.string   "name",                        :limit => 45
  end

  add_index "products", ["product_brand_id"], :name => "index_products_on_product_brand_id"
  add_index "products", ["product_category_id"], :name => "index_products_on_product_category_id"
  add_index "products", ["product_department_id"], :name => "index_products_on_product_department_id"
  add_index "products", ["product_kind_id"], :name => "index_products_on_product_kind_id"
  add_index "products", ["product_model_id"], :name => "index_products_on_product_model_id"

  create_table "purchase_order_items", :force => true do |t|
    t.integer  "purchase_order_id",                                           :default => 0
    t.integer  "purchase_requisition_item_id",                                :default => 0
    t.integer  "product_id",                                                  :default => 0
    t.integer  "quantity",                                                    :default => 0
    t.decimal  "unit_price",                   :precision => 12, :scale => 2, :default => 0.0
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_uom_id",                                              :default => 0
  end

  add_index "purchase_order_items", ["product_id"], :name => "index_purchase_order_items_on_product_id"
  add_index "purchase_order_items", ["product_uom_id"], :name => "index_purchase_order_items_on_product_uom_id"
  add_index "purchase_order_items", ["purchase_order_id"], :name => "index_purchase_order_items_on_purchase_order_id"
  add_index "purchase_order_items", ["purchase_requisition_item_id"], :name => "index_purchase_order_items_on_purchase_requisition_item_id"

  create_table "purchase_orders", :force => true do |t|
    t.date     "purchase_order_date"
    t.string   "purchase_order_number",   :limit => 20
    t.integer  "supplier_id",                           :default => 0
    t.string   "term",                    :limit => 45
    t.string   "remark"
    t.integer  "purchase_requisition_id",               :default => 0
    t.boolean  "voided",                                :default => false
    t.boolean  "settled",                               :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "imported",                              :default => false
    t.boolean  "starred",                               :default => false
    t.string   "name"
    t.boolean  "payment_paid",                          :default => false
  end

  add_index "purchase_orders", ["name"], :name => "index_purchase_orders_on_name"
  add_index "purchase_orders", ["payment_paid"], :name => "index_purchase_orders_on_payment_paid"
  add_index "purchase_orders", ["purchase_requisition_id"], :name => "index_purchase_orders_on_purchase_requisition_id"
  add_index "purchase_orders", ["settled"], :name => "index_purchase_orders_on_settled"
  add_index "purchase_orders", ["supplier_id"], :name => "index_purchase_orders_on_supplier_id"
  add_index "purchase_orders", ["voided"], :name => "index_purchase_orders_on_voided"

  create_table "purchase_requisition_items", :force => true do |t|
    t.integer  "purchase_requisition_id",                                :default => 0
    t.integer  "product_id",                                             :default => 0
    t.integer  "supplier_id",                                            :default => 0
    t.integer  "quantity",                                               :default => 0
    t.decimal  "unit_price",              :precision => 12, :scale => 2, :default => 0.0
    t.string   "remark"
    t.boolean  "confirmed",                                              :default => false
    t.integer  "purchase_order_id",                                      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_uom_id",                                         :default => 0
  end

  add_index "purchase_requisition_items", ["product_uom_id"], :name => "index_purchase_requisition_items_on_product_uom_id"

  create_table "purchase_requisitions", :force => true do |t|
    t.date     "pr_date"
    t.string   "pr_number",        :limit => 20
    t.string   "remark"
    t.boolean  "void",                           :default => false
    t.integer  "issued_user_id",                 :default => 0
    t.integer  "approved_user_id",               :default => 0
    t.integer  "status_id",                      :default => 0
    t.integer  "company_id",                     :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "starred",                        :default => false
  end

  create_table "reports", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_order_items", :force => true do |t|
    t.integer  "sales_order_id",                                               :default => 0
    t.integer  "product_id",                                                   :default => 0
    t.integer  "product_uom_id",                                               :default => 0
    t.integer  "quantity",                                                     :default => 0
    t.decimal  "unit_price",                    :precision => 12, :scale => 2, :default => 0.0
    t.string   "remark"
    t.boolean  "confirmed",                                                    :default => false
    t.integer  "invoice_id",                                                   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "packing_list_id",                                              :default => 0
    t.string   "discounts",       :limit => 45
  end

  add_index "sales_order_items", ["confirmed"], :name => "index_sales_order_items_on_confirmed"
  add_index "sales_order_items", ["discounts"], :name => "index_sales_order_items_on_discounts"
  add_index "sales_order_items", ["invoice_id"], :name => "index_sales_order_items_on_invoice_id"
  add_index "sales_order_items", ["product_id"], :name => "index_sales_order_items_on_product_id"
  add_index "sales_order_items", ["product_uom_id"], :name => "index_sales_order_items_on_product_uom_id"
  add_index "sales_order_items", ["sales_order_id"], :name => "index_sales_order_items_on_sales_order_id"

  create_table "sales_orders", :force => true do |t|
    t.date     "sales_order_date"
    t.string   "sales_order_number", :limit => 20
    t.string   "remark"
    t.boolean  "void",                             :default => false
    t.integer  "issued_user_id",                   :default => 0
    t.integer  "approved_user_id",                 :default => 0
    t.integer  "status_id",                        :default => 0
    t.integer  "company_id",                       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "salesman_id",                      :default => 0
    t.integer  "customer_id"
  end

  add_index "sales_orders", ["approved_user_id"], :name => "index_sales_orders_on_approved_user_id"
  add_index "sales_orders", ["company_id"], :name => "index_sales_orders_on_company_id"
  add_index "sales_orders", ["customer_id"], :name => "index_sales_orders_on_customer_id"
  add_index "sales_orders", ["issued_user_id"], :name => "index_sales_orders_on_issued_user_id"
  add_index "sales_orders", ["salesman_id"], :name => "index_sales_orders_on_salesman_id"
  add_index "sales_orders", ["status_id"], :name => "index_sales_orders_on_status_id"

  create_table "salesmen", :force => true do |t|
    t.string   "code",            :limit => 45
    t.string   "name",            :limit => 45
    t.string   "company",         :limit => 20
    t.string   "address",         :limit => 20
    t.string   "city",            :limit => 45
    t.string   "postcode",        :limit => 20
    t.string   "email",           :limit => 45
    t.string   "office_contact",  :limit => 20
    t.string   "office_contact2", :limit => 20
    t.string   "fax_number",      :limit => 20
    t.string   "contact_person",  :limit => 45
    t.string   "contact_number",  :limit => 20
    t.string   "term",            :limit => 45
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
  end

  add_index "salesmen", ["city_id"], :name => "index_salesmen_on_city_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string   "company_name",                     :limit => 100
    t.string   "company_address_one",              :limit => 100
    t.string   "company_address_two",              :limit => 100
    t.string   "company_postcode",                 :limit => 5
    t.string   "company_city",                     :limit => 45
    t.string   "company_country",                  :limit => 45
    t.string   "product_prefix_code",              :limit => 6
    t.integer  "product_last_number",              :limit => 8,   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "purchase_requisition_last_number",                :default => 10000
    t.string   "purchase_requisition_code",                       :default => "PR"
    t.integer  "purchase_order_last_number",                      :default => 10000
    t.string   "purchase_order_code",                             :default => "PO"
    t.integer  "invoice_last_number",                             :default => 10000
    t.string   "invoice_code",                                    :default => "INV"
    t.integer  "grn_last_number",                                 :default => 10000
    t.string   "grn_code",                                        :default => "GRN"
    t.integer  "sales_order_last_number",                         :default => 10000
    t.string   "sales_order_code",                                :default => "SO"
    t.string   "packing_list_code",                               :default => "PL"
    t.integer  "packing_list_last_number",                        :default => 10000
    t.string   "delivery_order_code",                             :default => "DO"
    t.integer  "delivery_order_last_number",                      :default => 10000
    t.string   "customer_credit_note_code",                       :default => "CCN"
    t.integer  "customer_credit_note_last_number",                :default => 10000
    t.string   "customer_debit_note_code",                        :default => "CDN"
    t.integer  "customer_debit_note_last_number",                 :default => 10000
    t.string   "supplier_credit_note_code",                       :default => "SCN"
    t.integer  "supplier_credit_note_last_number",                :default => 10000
    t.string   "supplier_debit_note_code",                        :default => "SDN"
    t.integer  "supplier_debit_note_last_number",                 :default => 10000
    t.string   "customer_payment_code",                           :default => "CP"
    t.integer  "customer_payment_last_number",                    :default => 10000
    t.string   "supplier_payment_code",                           :default => "SP"
    t.integer  "supplier_payment_last_number",                    :default => 10000
    t.string   "stock_adjustment_code",                           :default => "SA"
    t.integer  "stock_adjustment_last_number",                    :default => 10000
    t.string   "stock_transfer_code",                             :default => "ST"
    t.integer  "stock_transfer_last_number",                      :default => 10000
    t.string   "stock_disposal_code",                             :default => "SD"
    t.integer  "stock_disposal_last_number",                      :default => 10000
    t.string   "phone_number",                     :limit => 20
    t.string   "fax_number",                       :limit => 20
    t.string   "pack_code",                                       :default => "PM"
    t.integer  "pack_last_number",                                :default => 10000
  end

  create_table "stock_adjustment_items", :force => true do |t|
    t.integer  "stock_adjustment_id", :default => 0
    t.integer  "product_id",          :default => 0
    t.integer  "quantity",            :default => 0
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock_location_id"
    t.boolean  "posted",              :default => false
    t.integer  "product_uom_id"
  end

  add_index "stock_adjustment_items", ["product_uom_id"], :name => "index_stock_adjustment_items_on_product_uom_id"

  create_table "stock_adjustments", :force => true do |t|
    t.string   "stock_adjustment_number", :limit => 20
    t.date     "stock_date"
    t.string   "remark"
    t.integer  "user_id",                               :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "posted",                                :default => false
    t.boolean  "settled",                               :default => false
    t.boolean  "voided",                                :default => false
  end

  add_index "stock_adjustments", ["settled"], :name => "index_stock_adjustments_on_settled"
  add_index "stock_adjustments", ["voided"], :name => "index_stock_adjustments_on_voided"

  create_table "stock_counts", :force => true do |t|
    t.integer  "stock_location_id",                                                   :null => false
    t.integer  "product_uom_item_id",                                                 :null => false
    t.decimal  "opening_balance",     :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "quantity",            :precision => 12, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "product_uom_id"
    t.integer  "product_location_id"
    t.integer  "product_rack_id"
  end

  add_index "stock_counts", ["product_id"], :name => "index_stock_counts_on_product_id"
  add_index "stock_counts", ["product_location_id"], :name => "index_stock_counts_on_product_location_id"
  add_index "stock_counts", ["product_rack_id"], :name => "index_stock_counts_on_product_rack_id"
  add_index "stock_counts", ["product_uom_id"], :name => "index_stock_counts_on_product_uom_id"
  add_index "stock_counts", ["product_uom_item_id"], :name => "index_stock_counts_on_product_uom_item_id"
  add_index "stock_counts", ["stock_location_id"], :name => "index_stock_counts_on_stock_location_id"

  create_table "stock_disposal_items", :force => true do |t|
    t.integer  "stock_disposal_id", :default => 0
    t.integer  "product_id",        :default => 0
    t.integer  "product_uom_id",    :default => 0
    t.integer  "stock_location_id", :default => 0
    t.integer  "quantity",          :default => 0
    t.string   "description"
    t.boolean  "posted",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stock_disposal_items", ["product_id"], :name => "index_stock_disposal_items_on_product_id"
  add_index "stock_disposal_items", ["product_uom_id"], :name => "index_stock_disposal_items_on_product_uom_id"
  add_index "stock_disposal_items", ["stock_disposal_id"], :name => "index_stock_disposal_items_on_stock_disposal_id"
  add_index "stock_disposal_items", ["stock_location_id"], :name => "index_stock_disposal_items_on_stock_location_id"

  create_table "stock_disposals", :force => true do |t|
    t.string   "stock_disposal_number", :limit => 20
    t.date     "stock_disposal_date"
    t.string   "remark"
    t.boolean  "posted",                              :default => false
    t.integer  "user_id",                             :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "settled",                             :default => false
    t.boolean  "voided",                              :default => false
  end

  add_index "stock_disposals", ["settled"], :name => "index_stock_disposals_on_settled"
  add_index "stock_disposals", ["user_id"], :name => "index_stock_disposals_on_user_id"
  add_index "stock_disposals", ["voided"], :name => "index_stock_disposals_on_voided"

  create_table "stock_locations", :force => true do |t|
    t.integer  "product_rack_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "product_location_id"
  end

  add_index "stock_locations", ["product_location_id"], :name => "index_stock_locations_on_product_location_id"
  add_index "stock_locations", ["product_rack_id"], :name => "index_stock_locations_on_product_rack_id"

  create_table "stock_transfer_items", :force => true do |t|
    t.integer  "stock_transfer_id",      :default => 0
    t.integer  "product_id",             :default => 0
    t.integer  "from_stock_location_id", :default => 0
    t.integer  "to_stock_location_id",   :default => 0
    t.integer  "quantity",               :default => 0
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_uom_id"
    t.boolean  "posted",                 :default => false
  end

  add_index "stock_transfer_items", ["from_stock_location_id"], :name => "index_stock_transfer_items_on_from_product_rack_id"
  add_index "stock_transfer_items", ["posted"], :name => "index_stock_transfer_items_on_posted"
  add_index "stock_transfer_items", ["product_id"], :name => "index_stock_transfer_items_on_product_id"
  add_index "stock_transfer_items", ["product_uom_id"], :name => "index_stock_transfer_items_on_product_uom_id"
  add_index "stock_transfer_items", ["stock_transfer_id"], :name => "index_stock_transfer_items_on_stock_transfer_id"
  add_index "stock_transfer_items", ["to_stock_location_id"], :name => "index_stock_transfer_items_on_to_product_rack_id"

  create_table "stock_transfers", :force => true do |t|
    t.string   "stock_transfer_number", :limit => 20
    t.date     "stock_transfer_date"
    t.string   "remark"
    t.integer  "user_id",                             :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "settled",                             :default => false
    t.boolean  "voided",                              :default => false
    t.boolean  "posted",                              :default => false
  end

  add_index "stock_transfers", ["posted"], :name => "index_stock_transfers_on_posted"
  add_index "stock_transfers", ["settled"], :name => "index_stock_transfers_on_settled"
  add_index "stock_transfers", ["user_id"], :name => "index_stock_transfers_on_user_id"
  add_index "stock_transfers", ["voided"], :name => "index_stock_transfers_on_voided"

  create_table "supplier_credit_note_items", :force => true do |t|
    t.integer  "supplier_credit_note_id",                                :default => 0
    t.integer  "product_id",                                             :default => 0
    t.integer  "product_uom_id",                                         :default => 0
    t.integer  "quantity",                                               :default => 0
    t.decimal  "unit_price",              :precision => 12, :scale => 2, :default => 0.0
    t.string   "remark"
    t.boolean  "posted",                                                 :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock_location_id"
  end

  add_index "supplier_credit_note_items", ["product_id"], :name => "index_supplier_credit_note_items_on_product_id"
  add_index "supplier_credit_note_items", ["product_uom_id"], :name => "index_supplier_credit_note_items_on_product_uom_id"
  add_index "supplier_credit_note_items", ["stock_location_id"], :name => "index_supplier_credit_note_items_on_stock_location_id"
  add_index "supplier_credit_note_items", ["supplier_credit_note_id"], :name => "index_supplier_credit_note_items_on_supplier_credit_note_id"

  create_table "supplier_credit_notes", :force => true do |t|
    t.string   "supplier_credit_note_number", :limit => 20
    t.date     "supplier_credit_note_date"
    t.string   "remark"
    t.boolean  "voided",                                    :default => false
    t.boolean  "posted",                                    :default => false
    t.integer  "supplier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "settled",                                   :default => false
  end

  add_index "supplier_credit_notes", ["settled"], :name => "index_supplier_credit_notes_on_settled"

  create_table "supplier_debit_note_items", :force => true do |t|
    t.integer  "supplier_debit_note_id",                                :default => 0
    t.integer  "product_id",                                            :default => 0
    t.integer  "product_uom_id",                                        :default => 0
    t.integer  "quantity",                                              :default => 0
    t.decimal  "unit_price",             :precision => 12, :scale => 2, :default => 0.0
    t.string   "remark"
    t.boolean  "posted",                                                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock_location_id"
  end

  add_index "supplier_debit_note_items", ["product_id"], :name => "index_supplier_debit_note_items_on_product_id"
  add_index "supplier_debit_note_items", ["product_uom_id"], :name => "index_supplier_debit_note_items_on_product_uom_id"
  add_index "supplier_debit_note_items", ["stock_location_id"], :name => "index_supplier_debit_note_items_on_stock_location_id"
  add_index "supplier_debit_note_items", ["supplier_debit_note_id"], :name => "index_supplier_debit_note_items_on_supplier_debit_note_id"

  create_table "supplier_debit_notes", :force => true do |t|
    t.string   "supplier_debit_note_number", :limit => 20
    t.date     "supplier_debit_note_date"
    t.string   "remark"
    t.boolean  "voided",                                   :default => false
    t.boolean  "posted",                                   :default => false
    t.integer  "supplier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "settled",                                  :default => false
  end

  add_index "supplier_debit_notes", ["settled"], :name => "index_supplier_debit_notes_on_settled"

  create_table "supplier_payment_items", :force => true do |t|
    t.integer  "supplier_payment_id",                                :default => 0
    t.integer  "purchase_order_id",                                  :default => 0
    t.decimal  "amount",              :precision => 12, :scale => 2, :default => 0.0
    t.string   "remark"
    t.decimal  "paid_amount",         :precision => 12, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supplier_payments", :force => true do |t|
    t.string   "supplier_payment_number", :limit => 20
    t.date     "supplier_payment_date"
    t.string   "remark"
    t.boolean  "voided",                                :default => false
    t.integer  "supplier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "posted",                                :default => false
    t.boolean  "settled",                               :default => false
    t.integer  "payment_method_id"
    t.date     "cheque_date"
    t.string   "cheque_number"
    t.string   "bank"
  end

  add_index "supplier_payments", ["payment_method_id"], :name => "index_supplier_payments_on_payment_method_id"
  add_index "supplier_payments", ["posted"], :name => "index_supplier_payments_on_posted"
  add_index "supplier_payments", ["settled"], :name => "index_supplier_payments_on_sattled"

  create_table "suppliers", :force => true do |t|
    t.string   "code",            :limit => 45
    t.string   "name",            :limit => 100
    t.string   "company_number",  :limit => 20
    t.string   "address"
    t.string   "city",            :limit => 45
    t.string   "postcode",        :limit => 10
    t.string   "email",           :limit => 45
    t.string   "office_contact",  :limit => 20
    t.string   "office_contact2", :limit => 20
    t.string   "fax_number",      :limit => 20
    t.string   "contact_person",  :limit => 45
    t.string   "contact_number",  :limit => 20
    t.string   "term",            :limit => 45
    t.string   "remark"
    t.boolean  "suspend",                        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
  end

  add_index "suppliers", ["city_id"], :name => "index_suppliers_on_city_id"

  create_table "transports", :force => true do |t|
    t.string   "code",            :limit => 45
    t.string   "name",            :limit => 45
    t.string   "company_number",  :limit => 20
    t.string   "address",         :limit => 20
    t.string   "city",            :limit => 45
    t.string   "postcode",        :limit => 20
    t.string   "email",           :limit => 45
    t.string   "office_contact",  :limit => 20
    t.string   "office_contact2", :limit => 20
    t.string   "fax_number",      :limit => 20
    t.string   "contact_person",  :limit => 45
    t.string   "contact_number",  :limit => 20
    t.string   "term",            :limit => 45
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
  end

  add_index "transports", ["city_id"], :name => "index_transports_on_city_id"

  create_table "users", :force => true do |t|
    t.string   "login",               :limit => 45,                    :null => false
    t.string   "name",                :limit => 45,                    :null => false
    t.string   "email",               :limit => 45,                    :null => false
    t.integer  "department_id",                                        :null => false
    t.boolean  "disabled",                          :default => false
    t.string   "crypted_password",                                     :null => false
    t.string   "password_salt",                                        :null => false
    t.string   "persistence_token",                                    :null => false
    t.string   "single_access_token",                                  :null => false
    t.string   "perishable_token",                                     :null => false
    t.integer  "login_count",                       :default => 0,     :null => false
    t.integer  "failed_login_count",                :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["department_id"], :name => "index_users_on_department_id"

end
