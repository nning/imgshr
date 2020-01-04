# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_04_215556) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "boss_tokens", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "slug", null: false, collation: "utf8_bin"
    t.integer "gallery_id"
    t.integer "github_uid"
    t.string "github_login"
    t.index ["gallery_id"], name: "index_boss_tokens_on_gallery_id", unique: true
    t.index ["slug"], name: "index_boss_tokens_on_slug", unique: true
  end

  create_table "device_links", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "gallery_id"
    t.string "slug", null: false, collation: "utf8_bin"
    t.boolean "disabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gallery_id"], name: "index_device_links_on_gallery_id"
    t.index ["slug"], name: "index_device_links_on_slug", unique: true
  end

  create_table "file_releases", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "branch"
  end

  create_table "galleries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "slug", null: false, collation: "utf8_bin"
    t.string "name"
    t.integer "visits", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "read_only", default: false
    t.boolean "ratings_enabled", default: true, null: false
    t.boolean "endless_page", default: true, null: false
    t.boolean "device_links_only", default: false
    t.boolean "client_encrypted", default: false
    t.index ["slug"], name: "index_galleries_on_slug", unique: true
  end

  create_table "milestones", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "gallery_id"
    t.datetime "time", null: false
    t.string "description", null: false
    t.boolean "show_on_pictures", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gallery_id"], name: "index_milestones_on_gallery_id"
  end

  create_table "pictures", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "gallery_id", null: false
    t.string "image_fingerprint"
    t.string "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.timestamp "order_date"
    t.integer "ratings_count"
    t.boolean "image_processing"
    t.text "raw_label_list"
    t.boolean "ignore_exif_date", default: false
    t.index ["gallery_id"], name: "index_pictures_on_gallery_id"
    t.index ["image_fingerprint"], name: "index_pictures_on_image_fingerprint"
    t.index ["order_date"], name: "index_pictures_on_order_date"
  end

  create_table "ratings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "picture_id"
    t.integer "score", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["picture_id"], name: "index_ratings_on_picture_id"
  end

  create_table "taggings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "temp_links", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "picture_id"
    t.string "slug", null: false, collation: "utf8_bin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["picture_id"], name: "index_temp_links_on_picture_id"
    t.index ["slug"], name: "index_temp_links_on_slug", unique: true
  end

  add_foreign_key "device_links", "galleries"
  add_foreign_key "milestones", "galleries"
  add_foreign_key "ratings", "pictures"
  add_foreign_key "temp_links", "pictures"
end
