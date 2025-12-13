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

ActiveRecord::Schema[8.0].define(version: 2025_12_13_130837) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "grades", force: :cascade do |t|
    t.datetime "date"
    t.boolean "is_solemnity", default: false
    t.string "liturgical_color"
    t.string "liturgical_time"
    t.string "description"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_grades_on_deleted_at"
  end

  create_table "pastorals", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "coordinator_id", null: false
    t.bigint "vice_coordinator_id", null: false
    t.string "description"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coordinator_id"], name: "index_pastorals_on_coordinator_id"
    t.index ["deleted_at"], name: "index_pastorals_on_deleted_at"
    t.index ["name"], name: "index_pastorals_on_name", unique: true
    t.index ["vice_coordinator_id"], name: "index_pastorals_on_vice_coordinator_id"
  end

  create_table "reader_grades", force: :cascade do |t|
    t.bigint "reader_id", null: false
    t.bigint "grade_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reader_type"
    t.index ["deleted_at"], name: "index_reader_grades_on_deleted_at"
    t.index ["grade_id"], name: "index_reader_grades_on_grade_id"
    t.index ["reader_id"], name: "index_reader_grades_on_reader_id"
  end

  create_table "readers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "disponibility", default: [], array: true
    t.string "read_types", default: [], array: true
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_readers_on_deleted_at"
    t.index ["user_id"], name: "index_readers_on_user_id"
  end

  create_table "user_pastorals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "pastoral_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_user_pastorals_on_deleted_at"
    t.index ["pastoral_id"], name: "index_user_pastorals_on_pastoral_id"
    t.index ["user_id"], name: "index_user_pastorals_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "is_coordinator", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "pastorals", "users", column: "coordinator_id"
  add_foreign_key "pastorals", "users", column: "vice_coordinator_id"
  add_foreign_key "reader_grades", "grades"
  add_foreign_key "reader_grades", "readers"
  add_foreign_key "readers", "users"
  add_foreign_key "user_pastorals", "pastorals"
  add_foreign_key "user_pastorals", "users"
end
