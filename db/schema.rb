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

ActiveRecord::Schema.define(version: 20151025132351) do

  create_table "boss_tokens", force: :cascade do |t|
    t.string  "slug",       null: false
    t.integer "gallery_id"
  end

  add_index "boss_tokens", ["gallery_id"], name: "index_boss_tokens_on_gallery_id", unique: true
  add_index "boss_tokens", ["slug"], name: "index_boss_tokens_on_slug", unique: true

  create_table "galleries", force: :cascade do |t|
    t.string   "slug",                            null: false
    t.string   "name"
    t.integer  "visits",          default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read_only",       default: false
    t.boolean  "ratings_enabled", default: true,  null: false
    t.boolean  "endless_page",    default: true,  null: false
  end

  add_index "galleries", ["slug"], name: "index_galleries_on_slug", unique: true

  create_table "pictures", force: :cascade do |t|
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
    t.string   "camera"
    t.float    "focal_length"
    t.float    "aperture"
    t.string   "shutter_speed"
    t.integer  "iso_speed"
    t.integer  "flash"
    t.text     "dimensions"
    t.datetime "order_date"
    t.integer  "ratings_count"
  end

  add_index "pictures", ["gallery_id"], name: "index_pictures_on_gallery_id"
  add_index "pictures", ["image_fingerprint"], name: "index_pictures_on_image_fingerprint"
  add_index "pictures", ["order_date"], name: "index_pictures_on_order_date"

  create_table "ratings", force: :cascade do |t|
    t.integer  "picture_id"
    t.integer  "score",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ratings", ["picture_id"], name: "index_ratings_on_picture_id"

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

end
