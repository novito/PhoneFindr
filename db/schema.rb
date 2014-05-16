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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140515051744) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_pages", force: true do |t|
    t.integer  "source_id"
    t.datetime "last_parsed"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "brand_id"
  end

  create_table "category_parsing_results", force: true do |t|
    t.integer  "category_page_id"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_categories", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_pages", force: true do |t|
    t.string   "url"
    t.datetime "last_parsed"
    t.integer  "category_parsing_result_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_specifications", force: true do |t|
    t.text     "name"
    t.text     "value"
    t.integer  "device_page"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "devices", force: true do |t|
    t.integer  "device_page_id"
    t.string   "picture_url"
    t.datetime "date"
    t.boolean  "available"
    t.text     "operating_system"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "announced"
    t.string   "raw_sim"
    t.string   "raw_status"
    t.string   "raw_network_2g"
    t.string   "raw_network_3g"
    t.string   "raw_network_4g"
    t.string   "raw_dimensions"
    t.string   "raw_weight"
    t.string   "raw_display_type"
    t.string   "raw_display_size"
    t.string   "raw_sound_alert_types"
    t.string   "raw_sound_loudspeaker"
    t.string   "raw_sound_35_mm_jack"
  end

  create_table "sources", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
