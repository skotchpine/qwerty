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

ActiveRecord::Schema.define(version: 2020_10_13_164211) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exercises", force: :cascade do |t|
    t.bigint "lesson_id", null: false
    t.integer "position", null: false
    t.string "content", null: false
    t.string "title", null: false
    t.integer "max_typos", null: false
    t.integer "min_wpm", null: false
    t.integer "fast_wpm", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lesson_id"], name: "index_exercises_on_lesson_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.integer "position", null: false
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "exercise_id", null: false
    t.integer "right", null: false
    t.integer "wrong", null: false
    t.integer "accuracy", null: false
    t.integer "wpm", null: false
    t.boolean "complete", null: false
    t.boolean "accurate", null: false
    t.boolean "fast", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exercise_id"], name: "index_submissions_on_exercise_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "exercises", "lessons"
  add_foreign_key "submissions", "exercises"
  add_foreign_key "submissions", "users"
end
