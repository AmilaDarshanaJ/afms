# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_03_02_082102) do
  create_table "activities", force: :cascade do |t|
    t.string "land"
    t.date "start_date"
    t.date "end_date"
    t.text "summary"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "land_id", null: false
    t.index ["land_id"], name: "index_activities_on_land_id"
  end

  create_table "aspects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crop_types", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unit"
  end

  create_table "financial_records", force: :cascade do |t|
    t.integer "land_id", null: false
    t.string "category"
    t.decimal "amount", precision: 10, scale: 2
    t.date "transaction_date"
    t.text "description"
    t.integer "transaction_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["land_id"], name: "index_financial_records_on_land_id"
  end

  create_table "harvests", force: :cascade do |t|
    t.integer "land_id", null: false
    t.date "planned_date"
    t.date "actual_date"
    t.decimal "amount"
    t.string "unit"
    t.string "crop_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["land_id"], name: "index_harvests_on_land_id"
  end

  create_table "incomes", force: :cascade do |t|
    t.integer "land_id", null: false
    t.integer "harvest_id", null: false
    t.date "date"
    t.integer "quantity"
    t.decimal "price_per_unit"
    t.decimal "total_amount"
    t.string "buyer"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["harvest_id"], name: "index_incomes_on_harvest_id"
    t.index ["land_id"], name: "index_incomes_on_land_id"
  end

  create_table "lands", force: :cascade do |t|
    t.string "name"
    t.string "crop_type"
    t.string "address"
    t.decimal "latitude"
    t.decimal "longitude"
    t.decimal "extent"
    t.string "harvest_frequency"
    t.string "boundary_north"
    t.string "boundary_south"
    t.string "boundary_east"
    t.string "boundary_west"
    t.string "owner_manager_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "activities", "lands"
  add_foreign_key "financial_records", "lands"
  add_foreign_key "harvests", "lands"
  add_foreign_key "incomes", "harvests"
  add_foreign_key "incomes", "lands"
  add_foreign_key "sessions", "users"
end
