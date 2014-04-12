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

ActiveRecord::Schema.define(version: 20140412001319) do

  create_table "hosts", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.integer  "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hosts", ["institution_id"], name: "index_hosts_on_institution_id"
  add_index "hosts", ["url"], name: "index_hosts_on_url", unique: true

  create_table "institutions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "institutions", ["name"], name: "index_institutions_on_name", unique: true

  create_table "layers", force: true do |t|
    t.string   "name"
    t.string   "geoserver_layername"
    t.string   "access"
    t.text     "description"
    t.string   "bbox"
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "layers", ["host_id"], name: "index_layers_on_host_id"

  create_table "statuses", force: true do |t|
    t.string   "res_code"
    t.string   "res_message"
    t.decimal  "res_time"
    t.string   "status"
    t.string   "status_message"
    t.integer  "layer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["layer_id"], name: "index_statuses_on_layer_id"

end
