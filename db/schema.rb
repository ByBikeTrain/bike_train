# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130605173837) do

  create_table "addresses", :force => true do |t|
    t.string   "line_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "phone"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.float    "lat"
    t.float    "lng"
  end

  create_table "group_memberships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "is_admin"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.integer  "origin_address_id"
    t.integer  "destination_address_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "name"
    t.string   "description"
    t.text     "origin_address_line"
    t.text     "destination_address_line"
    t.float    "origin_address_lat"
    t.float    "origin_address_lng"
    t.float    "destination_address_lat"
    t.float    "destination_address_lng"
  end

  create_table "messages", :force => true do |t|
    t.text     "text"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "group_id"
    t.boolean  "read"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "routes", :force => true do |t|
    t.string   "origin_lat"
    t.string   "origin_lng"
    t.string   "destination_lat"
    t.string   "destination_lng"
    t.datetime "start_time"
    t.integer  "group_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "trips", :force => true do |t|
    t.string   "name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state_abbr"
    t.string   "zip_code"
    t.string   "country"
    t.float    "lat"
    t.float    "long"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "password_digest"
    t.boolean  "admin",              :default => false
    t.string   "remember_token"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "waypoints", :force => true do |t|
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "waypoints_routes", :force => true do |t|
    t.integer "waypoint_id"
    t.integer "route_id"
    t.integer "order"
  end

end
