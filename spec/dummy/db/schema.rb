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

ActiveRecord::Schema.define(:version => 20110612131855) do

  create_table "customers", :force => true do |t|
    t.string "name"
    t.string "state"
    t.string "zip"
  end

  create_table "name_search_names", :force => true do |t|
    t.string "value"
  end

  add_index "name_search_names", ["value"], :name => "index_name_search_names_on_value"

  create_table "name_search_nick_name_families", :force => true do |t|
  end

  create_table "name_search_nick_name_family_joins", :force => true do |t|
    t.integer "name_id"
    t.integer "nick_name_family_id"
  end

  add_index "name_search_nick_name_family_joins", ["name_id"], :name => "index_name_search_nick_name_family_joins_on_name_id"
  add_index "name_search_nick_name_family_joins", ["nick_name_family_id"], :name => "index_name_search_nick_name_family_joins_on_nick_name_family_id"

  create_table "name_search_searchables", :force => true do |t|
    t.integer "name_id"
    t.integer "searchable_id"
    t.string  "searchable_type"
  end

  add_index "name_search_searchables", ["name_id"], :name => "index_name_search_searchables_on_name_id"
  add_index "name_search_searchables", ["searchable_id", "searchable_type"], :name => "index_name_search_searchable"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
