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

ActiveRecord::Schema.define(version: 2019_01_20_192028) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.bigint "user_id"
    t.string "street"
    t.string "number"
    t.string "complement"
    t.string "district"
    t.string "city"
    t.string "state"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.boolean "default"
    t.string "latitude"
    t.string "longitude"
    t.bigint "route_id"
    t.bigint "landfill_id"
    t.index ["landfill_id"], name: "index_addresses_on_landfill_id"
    t.index ["route_id"], name: "index_addresses_on_route_id"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "collects", force: :cascade do |t|
    t.integer "status", default: 0
    t.integer "type_collect"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "collect_date"
    t.bigint "schedule_id"
    t.bigint "user_id"
    t.bigint "address_id"
    t.bigint "landfill_id"
    t.string "protocol_number"
    t.index ["address_id"], name: "index_collects_on_address_id"
    t.index ["landfill_id"], name: "index_collects_on_landfill_id"
    t.index ["schedule_id"], name: "index_collects_on_schedule_id"
    t.index ["user_id"], name: "index_collects_on_user_id"
  end

  create_table "collects_users", id: false, force: :cascade do |t|
    t.bigint "collect_id", null: false
    t.bigint "user_id", null: false
    t.index ["collect_id", "user_id"], name: "index_collects_users_on_collect_id_and_user_id", unique: true
    t.index ["user_id", "collect_id"], name: "index_collects_users_on_user_id_and_collect_id", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "evidence_id"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "admin_id"
    t.index ["admin_id"], name: "index_comments_on_admin_id"
    t.index ["evidence_id"], name: "index_comments_on_evidence_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contestations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "evidence_id"
    t.string "justification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evidence_id"], name: "index_contestations_on_evidence_id"
    t.index ["user_id"], name: "index_contestations_on_user_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.string "name"
    t.text "observation"
  end

  create_table "evidences", force: :cascade do |t|
    t.string "description"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "address_id"
    t.string "full_address"
    t.integer "evidence_type"
    t.integer "client_id"
    t.decimal "mulct_value"
    t.string "citizen_cpf"
    t.decimal "latitude"
    t.decimal "longitude"
    t.index ["address_id"], name: "index_evidences_on_address_id"
    t.index ["user_id"], name: "index_evidences_on_user_id"
  end

  create_table "infringements", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "evidence_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evidence_id"], name: "index_infringements_on_evidence_id"
    t.index ["user_id"], name: "index_infringements_on_user_id"
  end

  create_table "landfills", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
  end

  create_table "routes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "description"
  end

  create_table "schedules", force: :cascade do |t|
    t.date "work_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.boolean "full_schedule", default: false
    t.bigint "truck_id"
    t.index ["truck_id"], name: "index_schedules_on_truck_id"
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "schedules_routes", force: :cascade do |t|
    t.bigint "schedule_id"
    t.bigint "route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["route_id"], name: "index_schedules_routes_on_route_id"
    t.index ["schedule_id"], name: "index_schedules_routes_on_schedule_id"
  end

  create_table "trucks", force: :cascade do |t|
    t.string "brand"
    t.string "model"
    t.string "manufacture_year"
    t.string "color"
    t.string "plate_number"
    t.string "chassis_number"
    t.string "renavam_number"
    t.string "registration_number"
    t.string "maximum_load"
    t.string "m_3"
    t.string "axles_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "truck_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", default: "Client"
    t.string "cpf"
    t.string "phone_number"
    t.string "cnh"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "addresses", "landfills"
  add_foreign_key "addresses", "routes"
  add_foreign_key "collects", "addresses"
  add_foreign_key "collects", "landfills"
  add_foreign_key "collects", "schedules"
  add_foreign_key "collects", "users"
  add_foreign_key "comments", "admins"
  add_foreign_key "comments", "evidences"
  add_foreign_key "comments", "users"
  add_foreign_key "contestations", "evidences"
  add_foreign_key "contestations", "users"
  add_foreign_key "evidences", "addresses"
  add_foreign_key "evidences", "users"
  add_foreign_key "infringements", "evidences"
  add_foreign_key "infringements", "users"
  add_foreign_key "schedules", "trucks"
  add_foreign_key "schedules", "users"
  add_foreign_key "schedules_routes", "routes"
  add_foreign_key "schedules_routes", "schedules"
end
