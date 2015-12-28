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

ActiveRecord::Schema.define(version: 20151228100427) do

  create_table "boss_tokens", force: :cascade do |t|
    t.string  "slug",       limit: 255, null: false
    t.integer "gallery_id", limit: 4
  end

  add_index "boss_tokens", ["gallery_id"], name: "index_boss_tokens_on_gallery_id", unique: true, using: :btree
  add_index "boss_tokens", ["slug"], name: "index_boss_tokens_on_slug", unique: true, using: :btree

  create_table "galleries", force: :cascade do |t|
    t.string   "slug",            limit: 255,                 null: false
    t.string   "name",            limit: 255
    t.integer  "visits",          limit: 4,   default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read_only",                   default: false
    t.boolean  "ratings_enabled",             default: true,  null: false
    t.boolean  "endless_page",                default: true,  null: false
  end

  add_index "galleries", ["slug"], name: "index_galleries_on_slug", unique: true, using: :btree

  create_table "pictures", force: :cascade do |t|
    t.integer  "gallery_id",         limit: 4,     null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.string   "image_fingerprint",  limit: 255,   null: false
    t.string   "title",              limit: 255
    t.datetime "photographed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "camera",             limit: 255
    t.float    "focal_length",       limit: 24
    t.float    "aperture",           limit: 24
    t.string   "shutter_speed",      limit: 255
    t.integer  "iso_speed",          limit: 4
    t.integer  "flash",              limit: 4
    t.text     "dimensions",         limit: 65535
    t.datetime "order_date"
    t.integer  "ratings_count",      limit: 4
    t.boolean  "image_processing"
  end

  add_index "pictures", ["gallery_id"], name: "index_pictures_on_gallery_id", using: :btree
  add_index "pictures", ["image_fingerprint"], name: "index_pictures_on_image_fingerprint", using: :btree
  add_index "pictures", ["order_date"], name: "index_pictures_on_order_date", using: :btree

  create_table "ratings", force: :cascade do |t|
    t.integer  "picture_id", limit: 4
    t.integer  "score",      limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "ratings", ["picture_id"], name: "index_ratings_on_picture_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "temp_links", force: :cascade do |t|
    t.integer  "picture_id", limit: 4
    t.string   "slug",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "temp_links", ["picture_id"], name: "index_temp_links_on_picture_id", using: :btree

  add_foreign_key "ratings", "pictures"
  add_foreign_key "temp_links", "pictures"
end
