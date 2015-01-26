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

ActiveRecord::Schema.define(version: 20150123224019) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "hosts", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.integer  "institution_id"
    t.integer  "layers_count"
    t.integer  "pings_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hosts", ["institution_id"], name: "index_hosts_on_institution_id", using: :btree
  add_index "hosts", ["url"], name: "index_hosts_on_url", unique: true, using: :btree

  create_table "institutions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "institutions", ["name"], name: "index_institutions_on_name", unique: true, using: :btree

  create_table "layers", force: :cascade do |t|
    t.string   "name"
    t.string   "geoserver_layername"
    t.string   "access"
    t.text     "description"
    t.string   "bbox"
    t.integer  "host_id"
    t.integer  "statuses_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.boolean  "active"
  end

  add_index "layers", ["host_id"], name: "index_layers_on_host_id", using: :btree

  create_table "pings", force: :cascade do |t|
    t.boolean  "status"
    t.boolean  "latest"
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pings", ["host_id"], name: "index_pings_on_host_id", using: :btree

  create_table "statuses", force: :cascade do |t|
    t.string   "res_code"
    t.string   "res_message"
    t.decimal  "res_time"
    t.string   "status"
    t.text     "status_message"
    t.text     "submitted_query"
    t.boolean  "latest"
    t.integer  "layer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["layer_id"], name: "index_statuses_on_layer_id", using: :btree

end
