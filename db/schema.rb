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

ActiveRecord::Schema.define(version: 20140803204257) do

  create_table "delete_tokens", force: true do |t|
    t.string  "slug",       null: false
    t.integer "gallery_id"
  end

  add_index "delete_tokens", ["gallery_id"], name: "index_delete_tokens_on_gallery_id", unique: true
  add_index "delete_tokens", ["slug"], name: "index_delete_tokens_on_slug", unique: true

  create_table "galleries", force: true do |t|
    t.string   "slug",                   null: false
    t.string   "name"
    t.integer  "visits",     default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "galleries", ["slug"], name: "index_galleries_on_slug", unique: true

  create_table "pictures", force: true do |t|
    t.integer  "gallery_id",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_fingerprint",  null: false
    t.string   "title"
    t.datetime "photographed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
