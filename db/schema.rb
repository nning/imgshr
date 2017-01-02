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

ActiveRecord::Schema.define(version: 20170102194912) do

  create_table "boss_tokens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "slug",       null: false
    t.integer "gallery_id"
    t.integer "github_uid"
    t.index ["gallery_id"], name: "index_boss_tokens_on_gallery_id", unique: true, using: :btree
    t.index ["slug"], name: "index_boss_tokens_on_slug", unique: true, using: :btree
  end

  create_table "device_links", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "gallery_id"
    t.string   "slug",                       null: false
    t.boolean  "disabled",   default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["gallery_id"], name: "index_device_links_on_gallery_id", using: :btree
    t.index ["slug"], name: "index_device_links_on_slug", unique: true, using: :btree
  end

  create_table "file_releases", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "file_fingerprint",  null: false
    t.string   "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "branch"
  end

  create_table "galleries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "slug",                              null: false
    t.string   "name"
    t.integer  "visits",            default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read_only",         default: false
    t.boolean  "ratings_enabled",   default: true,  null: false
    t.boolean  "endless_page",      default: true,  null: false
    t.boolean  "device_links_only", default: false
    t.index ["slug"], name: "index_galleries_on_slug", unique: true, using: :btree
  end

  create_table "pictures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "gallery_id",                       null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_fingerprint",                null: false
    t.string   "title"
    t.datetime "photographed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "camera"
    t.float    "focal_length",       limit: 24
    t.float    "aperture",           limit: 24
    t.string   "shutter_speed"
    t.integer  "iso_speed"
    t.integer  "flash"
    t.text     "dimensions",         limit: 65535
    t.datetime "order_date"
    t.integer  "ratings_count"
    t.boolean  "image_processing"
    t.index ["gallery_id"], name: "index_pictures_on_gallery_id", using: :btree
    t.index ["image_fingerprint"], name: "index_pictures_on_image_fingerprint", using: :btree
    t.index ["order_date"], name: "index_pictures_on_order_date", using: :btree
  end

  create_table "ratings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "picture_id"
    t.integer  "score",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["picture_id"], name: "index_ratings_on_picture_id", using: :btree
  end

  create_table "taggings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name",                       collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "temp_links", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "picture_id"
    t.string   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["picture_id"], name: "index_temp_links_on_picture_id", using: :btree
    t.index ["slug"], name: "index_temp_links_on_slug", unique: true, using: :btree
  end

  add_foreign_key "device_links", "galleries"
  add_foreign_key "ratings", "pictures"
  add_foreign_key "temp_links", "pictures"
end
