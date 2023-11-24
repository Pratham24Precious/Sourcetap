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

ActiveRecord::Schema[7.0].define(version: 2023_11_23_131118) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "experts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "skills"
    t.integer "experience"
    t.string "mobile_no"
    t.string "current_city"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "experts_jobs", id: false, force: :cascade do |t|
    t.bigint "expert_id"
    t.bigint "job_id"
    t.index ["expert_id"], name: "index_experts_jobs_on_expert_id"
    t.index ["job_id"], name: "index_experts_jobs_on_job_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "skills_required"
    t.string "experience_level"
    t.string "location"
    t.string "salary_range"
    t.date "application_deadline"
    t.string "contact_email"
    t.string "contact_phone"
    t.boolean "applied", default: false
    t.bigint "recruiter_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recruiter_id"], name: "index_jobs_on_recruiter_id"
  end

  create_table "recruiters", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "company_name"
    t.string "city"
    t.string "mobile_no"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "jobs", "recruiters"
end
